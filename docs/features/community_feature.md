# Community Feature Documentation

## Overview
The Community feature is a comprehensive social platform that allows cricket players, coaches, clubs, and enthusiasts to connect, share content, compete in challenges, and track their performance on leaderboards.

## Features

### 1. **Feed Tab**
- General posts from community members
- Like, comment, and share functionality
- Post creation dialog
- User profiles with roles (Player, Coach, Club Manager, etc.)
- Time-based sorting

### 2. **News Tab**
- Official cricket news and announcements
- News articles from verified sources
- Image support for news posts
- Source attribution

### 3. **Challenges Tab**

#### Active Challenges
- Track progress on joined challenges
- Progress bar showing completion percentage
- Days remaining counter
- Participant count

#### Available Challenges
- Browse public challenges
- Filter by category:
  - Leather Ball
  - Tennis Ball
  - Box Cricket
- Challenge types:
  - Batting (runs, centuries, average)
  - Bowling (wickets, economy, maidens)
  - Fielding (catches, run-outs, stumpings)
  - All-Round
- Join button for available challenges
- Private challenges (invite-only)

#### Challenge Features
- **Trackable Progress**: Each participant's progress is tracked
- **Rankings**: Participant leaderboard within each challenge
- **Public/Private**: Challenges can be open to all or invite-only
- **Challenge Anyone**: Users can challenge their connections
- **Accept Challenges**: Users can accept challenges from anyone

### 4. **Leaderboards Tab**

#### Categories
- **Batting Leaderboard**
  - Total runs
  - Average
  - Strike rate
  - Centuries
  - Fifties

- **Bowling Leaderboard**
  - Total wickets
  - Economy rate
  - Average
  - Five-wicket hauls

- **Fielding Leaderboard**
  - Catches
  - Run-outs
  - Stumpings

#### Filters
- Overall (all categories combined)
- Leather Ball
- Tennis Ball
- Box Cricket

#### Features
- **Rank Display**: Top 3 ranks highlighted with gold/silver/bronze
- **Current User Highlight**: User's rank highlighted in green
- **Points System**: Each stat contributes to total points
- **Team Display**: Shows player's team affiliation

### 5. **Looking For Tab**
Dedicated section for recruitment and opportunities:

- **Player Recruitment**: Clubs/teams looking for players
- **Trainer/Coach Opportunities**: Positions for coaches
- **Staff Positions**: Other cricket-related roles
- **Requirements Chips**: Clear display of requirements
- **Location Filter**: Filter by city/region
- **Apply Button**: Direct application functionality

#### Looking For Post Features
- Role specification (Batsman, Bowler, Coach, Physio, etc.)
- Skills required
- Location
- Experience level
- Availability requirements
- Contact information

## Domain Model

### Post Entity
```dart
class Post extends Equatable {
  final String id;
  final String authorId;
  final String authorName;
  final String content;
  final List<String> images;
  final PostType type; // general, news, article, lookingFor
  final DateTime createdAt;
  final int likes;
  final int comments;
  final int shares;
  final bool isLiked;
  final Map<String, dynamic>? metadata; // For lookingFor posts
}
```

### Challenge Entity
```dart
class Challenge extends Equatable {
  final String id;
  final String title;
  final String description;
  final String creatorId;
  final ChallengeType type; // batting, bowling, fielding, allRound
  final ChallengeCategory category; // leatherBall, tennisBall, boxCricket
  final DateTime startDate;
  final DateTime endDate;
  final Map<String, dynamic> target; // e.g., {"runs": 100}
  final List<ChallengeParticipant> participants;
  final ChallengeStatus status; // upcoming, ongoing, completed
  final bool isPublic;
}

class ChallengeParticipant {
  final String userId;
  final String userName;
  final DateTime joinedAt;
  final Map<String, dynamic> progress; // Current stats
  final int rank;
}
```

### Leaderboard Entity
```dart
class LeaderboardEntry extends Equatable {
  final int rank;
  final String userId;
  final String userName;
  final LeaderboardStats stats;
  final int totalPoints;
  final String? team;
}

class LeaderboardStats {
  // Batting
  final int runs;
  final double battingAverage;
  final double strikeRate;
  final int centuries;
  final int fifties;
  
  // Bowling
  final int wickets;
  final double economy;
  final double bowlingAverage;
  final int fiveWickets;
  
  // Fielding
  final int catches;
  final int runOuts;
  final int stumpings;
}
```

## UI Components

### CommunityFeedScreen
**Location**: `lib/features/community/presentation/pages/community_feed_screen.dart`

**Features**:
- TabController with 5 tabs
- Search bar in header
- Create post button
- Responsive design using ResponsiveHelper
- Color-coded tabs and action buttons

**Widgets**:
- `_buildPostCard`: General post display
- `_buildNewsCard`: News article display
- `_buildChallengeCard`: Challenge display with progress
- `_buildLeaderboardEntry`: Leaderboard rank display
- `_buildLookingForCard`: Recruitment post display
- `_buildActionButton`: Like/comment/share buttons
- `_buildCategoryChip`: Filter chips
- `_buildSectionHeader`: Section title headers

## Navigation Integration

### MainShell Updates
**Index 9**: Community Feed Screen
**Icon**: `Icons.forum` / `Icons.forum_outlined`
**Label**: "Community"

### Quick Action Integration
Added Community quick action to home dashboard:
- **Title**: "Community"
- **Icon**: `Icons.forum`
- **Color**: `AppColors.primaryGreen`
- **Navigation**: Index 9

## User Flows

### 1. Creating a Post
1. Click "+" button in header
2. Dialog opens with text field
3. Type content
4. Click "Post"
5. Post appears in feed

### 2. Joining a Challenge
1. Navigate to Challenges tab
2. Browse "Available Challenges"
3. Review challenge details (type, category, target, days left)
4. Click "Join Challenge"
5. Challenge moves to "Your Active Challenges"
6. Track progress via progress bar

### 3. Creating a Challenge
1. Navigate to Challenges tab
2. Click create challenge button
3. Fill form:
   - Title and description
   - Type (batting/bowling/fielding/all-round)
   - Category (leather/tennis/box cricket)
   - Target metrics
   - Start and end dates
   - Public/Private toggle
4. Submit
5. Challenge is created

### 4. Challenging a Connection
1. Navigate to Network/Your Network
2. Select a connection
3. Click "Challenge" button
4. Select challenge type and metrics
5. Send challenge invitation
6. Connection receives notification

### 5. Viewing Leaderboards
1. Navigate to Leaderboards tab
2. Select type (Batting/Bowling/Fielding)
3. Filter by category (Overall/Leather/Tennis/Box Cricket)
4. View rankings with stats
5. Find your rank (highlighted in green)

### 6. Posting a "Looking For"
1. Click create post button
2. Select "Looking For" type
3. Fill metadata:
   - Role (Player, Coach, Trainer, etc.)
   - Skills required
   - Location
   - Experience level
   - Other requirements
4. Post
5. Appears in both Feed and Looking For tabs

### 7. Applying to Opportunity
1. Navigate to Looking For tab
2. Browse opportunities
3. Review requirements
4. Click "Apply"
5. Contact information shared or application form opens

## Responsive Design
All components use `ResponsiveHelper` for:
- Font sizes (getTitle1, getHeadline, getBody, getCaption)
- Spacing (getSpacing with sizes: small, medium, large)
- Border radius (getBorderRadius with sizes: small, medium, large)
- Icon sizes (getIconSize with sizes: small, medium, large)
- Padding values (getValue for mobile/tablet/desktop)

## Color Scheme
- **Primary Action**: `AppColors.primaryGreen` (Join, Apply, Post buttons)
- **Leather Ball**: `AppColors.accentBlue`
- **Tennis Ball**: `AppColors.primaryOrange`
- **Box Cricket**: `AppColors.success`
- **Warning/Alert**: `AppColors.warning`
- **Top Ranks**: `Colors.amber` (gold for top 3)
- **Current User**: `AppColors.primaryGreen` with 10% opacity background

## Future Enhancements

### BLoC Architecture (Next Phase)
- **CommunityEvent**: LoadFeed, LoadChallenges, LoadLeaderboards, CreatePost, LikePost, CommentOnPost, SharePost, JoinChallenge, UpdateProgress, FilterLeaderboard
- **CommunityState**: Initial, Loading, Loaded, PostCreated, ChallengeJoined, Error
- **CommunityBloc**: Event handlers with repository integration
- **CommunityRepository**: Interface for data operations
- **MockCommunityRepository**: Mock data for development

### Real-time Features
- Live feed updates
- Real-time leaderboard changes
- Challenge progress notifications
- New post notifications

### Advanced Features
- **Comments Section**: Nested comments on posts
- **Hashtags**: Tag posts with hashtags
- **Mentions**: Tag users with @username
- **Media Upload**: Support for images and videos
- **Challenge Categories**: More granular categorization
- **Team Challenges**: Challenges for entire teams
- **Verification Badges**: Verified players, coaches, clubs
- **Private Messaging**: Direct messages between users
- **Notifications**: Push notifications for likes, comments, challenges
- **Reports/Moderation**: Content reporting and moderation tools

## Testing Considerations
- Test all 5 tabs load correctly
- Test navigation from quick actions
- Test post creation dialog
- Test challenge join/leave functionality
- Test leaderboard filtering
- Test responsive design on different screen sizes
- Test search functionality
- Test infinite scroll for long feeds

## Performance Optimizations
- Lazy loading for feed items
- Image caching
- Pagination for leaderboards
- Debounced search
- Memoized widgets for list items

## Status
✅ **UI Complete**: All 5 tabs designed and integrated
✅ **Navigation**: Integrated into MainShell and Quick Actions
✅ **Responsive Design**: Full ResponsiveHelper implementation
✅ **Domain Entities**: Post, Challenge, Leaderboard models created
🔄 **BLoC Layer**: Pending (next phase)
🔄 **Repository**: Pending (next phase)
🔄 **Backend Integration**: Pending (future phase)

## Compilation Status
- **Errors**: 0
- **Warnings**: 3 info (unrelated to Community feature)
- **Status**: ✅ Ready for testing
