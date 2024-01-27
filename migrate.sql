ALTER TABLE comments  ADD INDEX comments_post_id_index(post_id);

ALTER TABLE posts ADD INDEX posts_created_at_index(created_at);
ALTER TABLE comments ADD INDEX posts_user_id_index(user_id);

ALTER TABLE posts ADD INDEX posts_user_id_index(user_id);
