# Community Feed Service Test Script
$BASE_URL = "http://localhost:8080/api/v1"
$testCount = 0
$passedCount = 0

function Test-Endpoint {
    param (
        [string]$Name,
        [string]$Method,
        [string]$Url,
        [object]$Body,
        [hashtable]$Headers,
        [int]$ExpectedStatus = 200
    )
    
    $script:testCount++
    Write-Host "`n[$script:testCount] Testing: $Name" -ForegroundColor Cyan
    
    try {
        $params = @{
            Uri = $Url
            Method = $Method
            ContentType = "application/json"
        }
        
        if ($Headers) {
            $params.Headers = $Headers
        }
        
        if ($Body) {
            $params.Body = ($Body | ConvertTo-Json -Depth 10)
            Write-Host "Request Body: $($params.Body)" -ForegroundColor Gray
        }
        
        $response = Invoke-WebRequest @params -UseBasicParsing
        $content = $response.Content | ConvertFrom-Json
        
        if ($response.StatusCode -eq $ExpectedStatus) {
            Write-Host "* PASSED (Status: $($response.StatusCode))" -ForegroundColor Green
            Write-Host "Response: $($response.Content)" -ForegroundColor Gray
            $script:passedCount++
            return $content
        } else {
            Write-Host "* FAILED - Expected status $ExpectedStatus, got $($response.StatusCode)" -ForegroundColor Red
            return $null
        }
    }
    catch {
        Write-Host "* FAILED - $($_.Exception.Message)" -ForegroundColor Red
        if ($_.Exception.Response) {
            $reader = [System.IO.StreamReader]::new($_.Exception.Response.GetResponseStream())
            $responseBody = $reader.ReadToEnd()
            Write-Host "Error Response: $responseBody" -ForegroundColor Red
        }
        return $null
    }
}

Write-Host "==================================" -ForegroundColor Yellow
Write-Host "Community Feed Service Test Suite" -ForegroundColor Yellow
Write-Host "==================================" -ForegroundColor Yellow

# Step 1: Login to get token
Write-Host "`n=== Step 1: Authentication ===" -ForegroundColor Yellow
$loginBody = @{
    email = "testuser@cricket.com"
    password = "Pass123!"
}

$loginResponse = Test-Endpoint -Name "Login" -Method "POST" -Url "$BASE_URL/auth/login" -Body $loginBody
if (-not $loginResponse) {
    Write-Host "`nFailed to login. Exiting tests." -ForegroundColor Red
    exit 1
}

$token = $loginResponse.data.access_token
$headers = @{
    "Authorization" = "Bearer $token"
}
Write-Host "Authentication Token: $token" -ForegroundColor Gray

# Step 2: List public feed (no auth required)
Write-Host "`n=== Step 2: Public Feed ===" -ForegroundColor Yellow
$feedResponse = Test-Endpoint -Name "Get Public Feed" -Method "GET" -Url "$BASE_URL/posts"
if ($feedResponse) {
    Write-Host "Found $($feedResponse.data.posts.Count) posts" -ForegroundColor Green
    foreach ($post in $feedResponse.data.posts) {
        Write-Host "  - Post by $($post.user_name): $($post.content)" -ForegroundColor Gray
    }
}

# Step 3: Filter feed by post type
Write-Host "`n=== Step 3: Filter Feed by Type ===" -ForegroundColor Yellow
Test-Endpoint -Name "Get Match Posts" -Method "GET" -Url "$BASE_URL/posts?type=match"
Test-Endpoint -Name "Get Training Posts" -Method "GET" -Url "$BASE_URL/posts?type=training"

# Step 4: Create a new post
Write-Host "`n=== Step 4: Create Post ===" -ForegroundColor Yellow
$newPost = @{
    content = "Just finished an amazing practice session! Feeling pumped for tomorrow's match!"
    media_urls = @()
    post_type = "training"
    visibility = "public"
}

$createPostResponse = Test-Endpoint -Name "Create Post" -Method "POST" -Url "$BASE_URL/posts" -Body $newPost -Headers $headers -ExpectedStatus 201
if ($createPostResponse) {
    $postId = $createPostResponse.data.id
    Write-Host "Created post ID: $postId" -ForegroundColor Green
}

# Step 5: Get post details
Write-Host "`n=== Step 5: Post Details ===" -ForegroundColor Yellow
if ($postId) {
    Test-Endpoint -Name "Get Post Details" -Method "GET" -Url "$BASE_URL/posts/$postId" -Headers $headers
}

# Step 6: Add comments
Write-Host "`n=== Step 6: Comments ===" -ForegroundColor Yellow
if ($postId) {
    $comment1 = @{
        content = "Great work! Keep it up!"
    }
    $commentResponse = Test-Endpoint -Name "Add Comment" -Method "POST" -Url "$BASE_URL/posts/$postId/comments" -Body $comment1 -Headers $headers -ExpectedStatus 201
    if ($commentResponse) {
        $commentId = $commentResponse.data.id
        Write-Host "Created comment ID: $commentId" -ForegroundColor Green
    }
    
    # Get all comments for the post
    $commentsResponse = Test-Endpoint -Name "Get Post Comments" -Method "GET" -Url "$BASE_URL/posts/$postId/comments"
    if ($commentsResponse) {
        Write-Host "Found $($commentsResponse.data.Count) comments" -ForegroundColor Green
    }
}

# Step 7: Like post
Write-Host "`n=== Step 7: Likes ===" -ForegroundColor Yellow
if ($postId) {
    Test-Endpoint -Name "Like Post" -Method "POST" -Url "$BASE_URL/posts/$postId/like" -Headers $headers
    
    # Verify like was added
    $postDetails = Test-Endpoint -Name "Get Post Details (After Like)" -Method "GET" -Url "$BASE_URL/posts/$postId" -Headers $headers
    if ($postDetails -and $postDetails.data.is_liked_by_user) {
        Write-Host "Post is now liked by user" -ForegroundColor Green
    }
}

# Step 8: Like comment
Write-Host "`n=== Step 8: Like Comment ===" -ForegroundColor Yellow
if ($commentId) {
    Test-Endpoint -Name "Like Comment" -Method "POST" -Url "$BASE_URL/comments/$commentId/like" -Headers $headers
}

# Step 9: Get existing post details (from sample data)
Write-Host "`n=== Step 9: Sample Data ===" -ForegroundColor Yellow
# Sample posts were created with IDs, but we don't know them. Let's just get the feed
$sampleFeed = Test-Endpoint -Name "Get Feed with Sample Data" -Method "GET" -Url "$BASE_URL/posts?limit=10"
if ($sampleFeed) {
    Write-Host "Sample posts in feed:" -ForegroundColor Green
    foreach ($post in $sampleFeed.data.posts) {
        Write-Host "  - [$($post.post_type)] $($post.user_name): $($post.content.Substring(0, [Math]::Min(50, $post.content.Length)))..." -ForegroundColor Gray
    }
}

# Step 10: Update post
Write-Host "`n=== Step 10: Update Post ===" -ForegroundColor Yellow
if ($postId) {
    $updatePost = @{
        content = "Just finished an amazing practice session! Feeling pumped for tomorrow's BIG match! [UPDATED]"
    }
    Test-Endpoint -Name "Update Post" -Method "PUT" -Url "$BASE_URL/posts/$postId" -Body $updatePost -Headers $headers
}

# Step 11: Unlike operations
Write-Host "`n=== Step 11: Unlike Operations ===" -ForegroundColor Yellow
if ($postId) {
    Test-Endpoint -Name "Unlike Post" -Method "DELETE" -Url "$BASE_URL/posts/$postId/like" -Headers $headers
}
if ($commentId) {
    Test-Endpoint -Name "Unlike Comment" -Method "DELETE" -Url "$BASE_URL/comments/$commentId/like" -Headers $headers
}

# Step 12: Delete comment
Write-Host "`n=== Step 12: Delete Comment ===" -ForegroundColor Yellow
if ($commentId) {
    Test-Endpoint -Name "Delete Comment" -Method "DELETE" -Url "$BASE_URL/comments/$commentId" -Headers $headers
}

# Step 13: Delete post
Write-Host "`n=== Step 13: Delete Post ===" -ForegroundColor Yellow
if ($postId) {
    Test-Endpoint -Name "Delete Post" -Method "DELETE" -Url "$BASE_URL/posts/$postId" -Headers $headers
}

# Final summary
Write-Host "`n==================================" -ForegroundColor Yellow
Write-Host "Test Summary" -ForegroundColor Yellow
Write-Host "==================================" -ForegroundColor Yellow
Write-Host "Total Tests: $testCount" -ForegroundColor Cyan
Write-Host "Passed: $passedCount" -ForegroundColor Green
Write-Host "Failed: $($testCount - $passedCount)" -ForegroundColor Red

if ($passedCount -eq $testCount) {
    Write-Host "`n*** ALL TESTS PASSED! ***" -ForegroundColor Green
} else {
    Write-Host "`n*** SOME TESTS FAILED ***" -ForegroundColor Red
}
