-- Expected failure: document ID 999 does not exist.
-- Run this file separately and inspect the foreign-key error.
INSERT INTO document_tags (document_id, tag_id)
VALUES (999, 10);
