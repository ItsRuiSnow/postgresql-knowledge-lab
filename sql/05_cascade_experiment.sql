-- This experiment makes a change and then undoes it: the fixture remains unchanged.
BEGIN;

-- Two links belong to document 2; they disappear when the document is deleted.
DELETE FROM documents WHERE id = 2;

-- Expected: 2 remaining documents, 2 remaining links, and 3 tags.
SELECT (SELECT COUNT(*) FROM documents) AS document_count,
       (SELECT COUNT(*) FROM document_tags) AS link_count,
       (SELECT COUNT(*) FROM tags) AS tag_count;

ROLLBACK;

-- Expected after ROLLBACK: 3 documents, 4 links, and 3 tags.
SELECT (SELECT COUNT(*) FROM documents) AS document_count,
       (SELECT COUNT(*) FROM document_tags) AS link_count,
       (SELECT COUNT(*) FROM tags) AS tag_count;
