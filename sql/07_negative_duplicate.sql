-- Expected failure: document 1 already has tag 10.
-- Run this file separately and inspect the unique/primary-key error.
INSERT INTO document_tags (document_id, tag_id)
VALUES (1, 10);
