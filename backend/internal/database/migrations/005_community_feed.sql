-- Community Feed Service Tables

-- Posts Table
CREATE TABLE IF NOT EXISTS posts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    media_urls TEXT[],
    post_type VARCHAR(50) DEFAULT 'general', -- general, match, training, achievement, question
    visibility VARCHAR(20) DEFAULT 'public', -- public, friends, private
    likes_count INT DEFAULT 0,
    comments_count INT DEFAULT 0,
    shares_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Comments Table
CREATE TABLE IF NOT EXISTS comments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    post_id UUID NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    likes_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Likes Table (for both posts and comments)
CREATE TABLE IF NOT EXISTS likes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    post_id UUID REFERENCES posts(id) ON DELETE CASCADE,
    comment_id UUID REFERENCES comments(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT like_target_check CHECK (
        (post_id IS NOT NULL AND comment_id IS NULL) OR
        (post_id IS NULL AND comment_id IS NOT NULL)
    ),
    UNIQUE(user_id, post_id),
    UNIQUE(user_id, comment_id)
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_posts_user ON posts(user_id);
CREATE INDEX IF NOT EXISTS idx_posts_created ON posts(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_posts_type ON posts(post_type);
CREATE INDEX IF NOT EXISTS idx_comments_post ON comments(post_id);
CREATE INDEX IF NOT EXISTS idx_comments_user ON comments(user_id);
CREATE INDEX IF NOT EXISTS idx_likes_post ON likes(post_id);
CREATE INDEX IF NOT EXISTS idx_likes_comment ON likes(comment_id);
CREATE INDEX IF NOT EXISTS idx_likes_user ON likes(user_id);

-- Sample Posts
INSERT INTO posts (
    id, user_id, content, post_type, visibility, likes_count, comments_count
) VALUES
(
    'ffffffff-ffff-ffff-ffff-ffffffffffff',
    '9a8e3277-1c4b-4f0c-84ed-b637fe461f89',
    'Just finished an amazing training session! Working on perfecting my cover drive. Any tips from experienced players? 🏏',
    'training',
    'public',
    12,
    3
),
(
    '11111111-1111-1111-1111-111111111112',
    'eba4cb24-307c-454b-982a-0c730efa8703',
    'Our team won the inter-district championship! Incredible team effort. Special thanks to our coach for the amazing strategies. 🏆🎉',
    'achievement',
    'public',
    45,
    8
),
(
    '22222222-2222-2222-2222-222222222222',
    '24925841-a3e8-40b5-858d-26636f39ac74',
    'Looking for practice partners in Bangalore area. Anyone interested in weekend nets? DM me!',
    'general',
    'public',
    7,
    5
);

-- Sample Comments
INSERT INTO comments (
    id, post_id, user_id, content, likes_count
) VALUES
(
    'cccccccc-1111-1111-1111-111111111111',
    'ffffffff-ffff-ffff-ffff-ffffffffffff',
    'eba4cb24-307c-454b-982a-0c730efa8703',
    'Keep your head still and watch the ball closely. Practice with a tennis ball against a wall!',
    5
),
(
    'cccccccc-2222-2222-2222-222222222222',
    'ffffffff-ffff-ffff-ffff-ffffffffffff',
    '24925841-a3e8-40b5-858d-26636f39ac74',
    'Focus on your footwork. Get to the pitch of the ball before playing the shot.',
    3
),
(
    'cccccccc-3333-3333-3333-333333333333',
    '11111111-1111-1111-1111-111111111112',
    '9a8e3277-1c4b-4f0c-84ed-b637fe461f89',
    'Congratulations! Well deserved victory! 🎊',
    8
);
