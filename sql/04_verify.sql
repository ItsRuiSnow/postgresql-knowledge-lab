-- Assertions for a freshly loaded Lesson 01 database.
-- The DO block raises an error if the observed data differs from the fixture.
DO $$
BEGIN
    IF (SELECT COUNT(*) FROM documents) <> 3 THEN
        RAISE EXCEPTION 'Expected 3 documents';
    END IF;

    IF (SELECT COUNT(*) FROM tags) <> 3 THEN
        RAISE EXCEPTION 'Expected 3 tags';
    END IF;

    IF (SELECT COUNT(*) FROM document_tags) <> 4 THEN
        RAISE EXCEPTION 'Expected 4 document-tag links';
    END IF;

    IF (
        SELECT COUNT(*)
        FROM documents AS d
        JOIN document_tags AS dt ON d.id = dt.document_id
        JOIN tags AS t ON dt.tag_id = t.id
        WHERE t.name = '数据库'
    ) <> 2 THEN
        RAISE EXCEPTION 'Expected 2 documents tagged 数据库';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM documents AS d
        JOIN document_tags AS dt ON d.id = dt.document_id
        JOIN tags AS t ON dt.tag_id = t.id
        WHERE d.id = 1 AND t.name = '数据库'
    ) OR NOT EXISTS (
        SELECT 1
        FROM documents AS d
        JOIN document_tags AS dt ON d.id = dt.document_id
        JOIN tags AS t ON dt.tag_id = t.id
        WHERE d.id = 2 AND t.name = '数据库'
    ) THEN
        RAISE EXCEPTION 'Unexpected document/tag mappings';
    END IF;

    RAISE NOTICE 'Lesson 01 checks passed (3 documents, 3 tags, 4 links, 2 database-tag documents).';
END;
$$;
