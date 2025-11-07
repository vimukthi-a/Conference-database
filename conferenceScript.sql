-- First, clean up everything
DROP TABLE Review CASCADE CONSTRAINTS;
DROP TABLE PaperAuthors CASCADE CONSTRAINTS;
DROP TABLE Paper CASCADE CONSTRAINTS;
DROP TABLE ContactAuthor CASCADE CONSTRAINTS;
DROP TABLE TopicsOfInterest CASCADE CONSTRAINTS;
DROP TABLE ReviewerLogin CASCADE CONSTRAINTS;
DROP TABLE Reviewer CASCADE CONSTRAINTS;
DROP TABLE AuthorLogin CASCADE CONSTRAINTS;
DROP TABLE Author CASCADE CONSTRAINTS;
DROP TABLE LOGINFO CASCADE CONSTRAINTS;
DROP TABLE Login CASCADE CONSTRAINTS;

-- Drop sequences
DROP SEQUENCE review_seq;
DROP SEQUENCE PAPER_ID_INCR;

--Drop view
DROP VIEW CONFERENCE_SUMMARY_REPORT; 
DROP VIEW PAPER_STATUS_REPORT_VIEW;


-- Create tables in proper order
CREATE TABLE Login (
    Username VARCHAR2(50) PRIMARY KEY,
    Password VARCHAR2(255) NOT NULL
);

CREATE TABLE LOGINFO (
    Transaction_DateTime TIMESTAMP PRIMARY KEY,
    TransactionType VARCHAR2(50) NOT NULL,
    Table_Name VARCHAR2(50) NOT NULL,
    Username VARCHAR2(50) NOT NULL,
    FOREIGN KEY (Username) REFERENCES Login(Username) ON DELETE CASCADE
);

CREATE TABLE Author (
    Email VARCHAR2(100) PRIMARY KEY,
    First_Name VARCHAR2(50) NOT NULL,
    Last_Name VARCHAR2(50) NOT NULL,
    OrganizationInfo VARCHAR2(100),
    Country VARCHAR2(50)
);

CREATE TABLE AuthorLogin (
    Username VARCHAR2(50) NOT NULL,
    Email VARCHAR2(100) PRIMARY KEY,
    FOREIGN KEY (Username) REFERENCES Login(Username) ON DELETE CASCADE,
    FOREIGN KEY (Email) REFERENCES Author(Email) ON DELETE CASCADE
);

CREATE TABLE Reviewer (
    Email VARCHAR2(100) PRIMARY KEY,
    First_Name VARCHAR2(50) NOT NULL,
    Last_Name VARCHAR2(50) NOT NULL,
    Phone_No VARCHAR2(20),
    Affiliation VARCHAR2(100),
    MaxPapers NUMBER,
    Experience CLOB
);

CREATE TABLE ReviewerLogin (
    Username VARCHAR2(50) NOT NULL,
    Email VARCHAR2(100) PRIMARY KEY,
    FOREIGN KEY (Username) REFERENCES Login(Username) ON DELETE CASCADE,
    FOREIGN KEY (Email) REFERENCES Reviewer(Email) ON DELETE CASCADE
);

CREATE TABLE TopicsOfInterest (
    Email VARCHAR2(100),
    Topic VARCHAR2(50),
    PRIMARY KEY (Email, Topic),
    FOREIGN KEY (Email) REFERENCES Reviewer(Email) ON DELETE CASCADE
);

CREATE SEQUENCE PAPER_ID_INCR
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE TABLE ContactAuthor (
    paperID NUMBER PRIMARY KEY,
    Email VARCHAR2(100) NOT NULL,
    FOREIGN KEY (Email) REFERENCES Author(Email) ON DELETE CASCADE
);

CREATE TABLE Paper (
    paperID NUMBER PRIMARY KEY,
    Title VARCHAR2(255) NOT NULL,
    FileName VARCHAR2(255) NOT NULL,
    PaperDesc CLOB,
    Submission_Date DATE NOT NULL,
    Tracks VARCHAR2(100),
    Status_Field VARCHAR2(255) NOT NULL,
    CHECK (Status_Field IN ('Submitted', 'Under Review', 'Accepted', 'Rejected', 'Published')),
    FOREIGN KEY (paperID) REFERENCES ContactAuthor(paperID) ON DELETE CASCADE
);

CREATE TABLE PaperAuthors (
    Author_Email VARCHAR2(100),
    Paper_ID NUMBER,
    AuthorOrder INT NOT NULL,
    PRIMARY KEY (Author_Email, Paper_ID),
    FOREIGN KEY (Author_Email) REFERENCES Author(Email) ON DELETE CASCADE,
    FOREIGN KEY (Paper_ID) REFERENCES Paper(paperID) ON DELETE CASCADE
);

CREATE SEQUENCE review_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE TABLE Review (
    reviewID NUMBER PRIMARY KEY,
    Submission_Date DATE NOT NULL,
    Readability NUMBER CHECK (Readability BETWEEN 1 AND 10),
    Originality NUMBER CHECK (Originality BETWEEN 1 AND 10),
    Relevance NUMBER CHECK (Relevance BETWEEN 1 AND 10),
    TechnicalMerit NUMBER CHECK (TechnicalMerit BETWEEN 1 AND 10),
    Reviewer_Email VARCHAR2(100) NOT NULL,
    Paper_ID NUMBER NOT NULL,
    FOREIGN KEY (Reviewer_Email) REFERENCES Reviewer(Email) ON DELETE CASCADE,
    FOREIGN KEY (Paper_ID) REFERENCES Paper(paperID) ON DELETE CASCADE
);

-- Create a simple trigger for review auto increment only
CREATE OR REPLACE TRIGGER review_auto_increment
BEFORE INSERT ON Review
FOR EACH ROW
BEGIN
    IF :NEW.reviewID IS NULL THEN
        :NEW.reviewID := review_seq.NEXTVAL;
    END IF;
END;
/

-- Insert test data
-- Login table
INSERT INTO Login (Username, Password) VALUES ('johnsmith', 'hashed_password1');
INSERT INTO Login (Username, Password) VALUES ('alicecooper', 'hashed_password2');
INSERT INTO Login (Username, Password) VALUES ('robertjohnson', 'hashed_password3');
INSERT INTO Login (Username, Password) VALUES ('emilydavis', 'hashed_password4');
INSERT INTO Login (Username, Password) VALUES ('michaelwilson', 'hashed_password5');
INSERT INTO Login (Username, Password) VALUES ('sarahjohn', 'hashed_password6');
INSERT INTO Login (Username, Password) VALUES ('davidbrown', 'hashed_password7');
INSERT INTO Login (Username, Password) VALUES ('reviewer1', 'rev_password1');
INSERT INTO Login (Username, Password) VALUES ('reviewer2', 'rev_password2');
INSERT INTO Login (Username, Password) VALUES ('reviewer3', 'rev_password3');
INSERT INTO Login (Username, Password) VALUES ('reviewer4', 'rev_password4');
INSERT INTO Login (Username, Password) VALUES ('reviewer5', 'rev_password5');
INSERT INTO Login (Username, Password) VALUES ('SYSTEM', 'system_password');

-- Author table
INSERT INTO Author (Email, First_Name, Last_Name, OrganizationInfo, Country) VALUES ('john.smith@example.com', 'John', 'Smith', 'University of Technology', 'USA');
INSERT INTO Author (Email, First_Name, Last_Name, OrganizationInfo, Country) VALUES ('alice.cooper@example.com', 'Alice', 'Cooper', 'Research Institute', 'Canada');
INSERT INTO Author (Email, First_Name, Last_Name, OrganizationInfo, Country) VALUES ('robert.johnson@example.com', 'Robert', 'Johnson', 'Tech Solutions Inc.', 'UK');
INSERT INTO Author (Email, First_Name, Last_Name, OrganizationInfo, Country) VALUES ('emily.davis@example.com', 'Emily', 'Davis', 'Innovation Labs', 'Australia');
INSERT INTO Author (Email, First_Name, Last_Name, OrganizationInfo, Country) VALUES ('michael.wilson@example.com', 'Michael', 'Wilson', 'Advanced Research Center', 'Germany');
INSERT INTO Author (Email, First_Name, Last_Name, OrganizationInfo, Country) VALUES ('sarah.johnson@example.com', 'Sarah', 'John', 'Advanced Research Center', 'Germany');
INSERT INTO Author (Email, First_Name, Last_Name, OrganizationInfo, Country) VALUES ('david.brown@example.com', 'David', 'Brown', 'Advanced Research Center', 'Germany');

-- AuthorLogin table
INSERT INTO AuthorLogin (Username, Email) VALUES ('johnsmith', 'john.smith@example.com');
INSERT INTO AuthorLogin (Username, Email) VALUES ('alicecooper', 'alice.cooper@example.com');
INSERT INTO AuthorLogin (Username, Email) VALUES ('robertjohnson', 'robert.johnson@example.com');
INSERT INTO AuthorLogin (Username, Email) VALUES ('emilydavis', 'emily.davis@example.com');
INSERT INTO AuthorLogin (Username, Email) VALUES ('michaelwilson', 'michael.wilson@example.com');
INSERT INTO AuthorLogin (Username, Email) VALUES ('sarahjohn', 'sarah.johnson@example.com');
INSERT INTO AuthorLogin (Username, Email) VALUES ('davidbrown', 'david.brown@example.com');

-- Reviewer table
INSERT INTO Reviewer (Email, First_Name, Last_Name, Phone_No, Affiliation, MaxPapers, Experience) VALUES ('reviewer1@university.edu', 'James', 'Anderson', '+1-555-123-4567', 'University of Science', 5, '10 years in AI research');
INSERT INTO Reviewer (Email, First_Name, Last_Name, Phone_No, Affiliation, MaxPapers, Experience) VALUES ('reviewer2@research.org', 'Emma', 'Taylor', '+1-555-234-5678', 'Research Foundation', 3, '8 years in database systems');
INSERT INTO Reviewer (Email, First_Name, Last_Name, Phone_No, Affiliation, MaxPapers, Experience) VALUES ('reviewer3@institute.edu', 'Daniel', 'Martinez', '+1-555-345-6789', 'Technical Institute', 4, '12 years in cybersecurity');
INSERT INTO Reviewer (Email, First_Name, Last_Name, Phone_No, Affiliation, MaxPapers, Experience) VALUES ('reviewer4@university.edu', 'Sophia', 'Garcia', '+1-555-456-7890', 'University of Engineering', 6, '7 years in machine learning');
INSERT INTO Reviewer (Email, First_Name, Last_Name, Phone_No, Affiliation, MaxPapers, Experience) VALUES ('reviewer5@research.org', 'William', 'Johnson', '+1-555-567-8901', 'Science Academy', 4, '15 years in cloud computing');

-- ReviewerLogin table
INSERT INTO ReviewerLogin (Username, Email) VALUES ('reviewer1', 'reviewer1@university.edu');
INSERT INTO ReviewerLogin (Username, Email) VALUES ('reviewer2', 'reviewer2@research.org');
INSERT INTO ReviewerLogin (Username, Email) VALUES ('reviewer3', 'reviewer3@institute.edu');
INSERT INTO ReviewerLogin (Username, Email) VALUES ('reviewer4', 'reviewer4@university.edu');
INSERT INTO ReviewerLogin (Username, Email) VALUES ('reviewer5', 'reviewer5@research.org');

-- TopicsOfInterest table
INSERT INTO TopicsOfInterest (Email, Topic) VALUES ('reviewer1@university.edu', 'Machine Learning');
INSERT INTO TopicsOfInterest (Email, Topic) VALUES ('reviewer1@university.edu', 'Neural Networks');
INSERT INTO TopicsOfInterest (Email, Topic) VALUES ('reviewer2@research.org', 'Database Systems');
INSERT INTO TopicsOfInterest (Email, Topic) VALUES ('reviewer2@research.org', 'Data Mining');
INSERT INTO TopicsOfInterest (Email, Topic) VALUES ('reviewer3@institute.edu', 'Network Security');
INSERT INTO TopicsOfInterest (Email, Topic) VALUES ('reviewer3@institute.edu', 'Cryptography');
INSERT INTO TopicsOfInterest (Email, Topic) VALUES ('reviewer4@university.edu', 'AI Applications');
INSERT INTO TopicsOfInterest (Email, Topic) VALUES ('reviewer4@university.edu', 'Computer Vision');
INSERT INTO TopicsOfInterest (Email, Topic) VALUES ('reviewer5@research.org', 'Cloud Computing');
INSERT INTO TopicsOfInterest (Email, Topic) VALUES ('reviewer5@research.org', 'Distributed Systems');

-- Log entries
--INSERT INTO LOGINFO (Transaction_DateTime, TransactionType, Table_Name, Username) VALUES (TO_TIMESTAMP('2024-04-01 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'INSERT', 'Paper', 'johnsmith');
--INSERT INTO LOGINFO (Transaction_DateTime, TransactionType, Table_Name, Username) VALUES (TO_TIMESTAMP('2024-01-11 15:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'INSERT', 'Author', 'alicecooper');
--INSERT INTO LOGINFO (Transaction_DateTime, TransactionType, Table_Name, Username) VALUES (TO_TIMESTAMP('2024-02-08 09:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'UPDATE', 'Paper', 'robertjohnson');
--INSERT INTO LOGINFO (Transaction_DateTime, TransactionType, Table_Name, Username) VALUES (TO_TIMESTAMP('2024-03-01 14:20:00', 'YYYY-MM-DD HH24:MI:SS'), 'INSERT', 'Review', 'reviewer1');
--INSERT INTO LOGINFO (Transaction_DateTime, TransactionType, Table_Name, Username) VALUES (TO_TIMESTAMP('2024-05-10 11:10:00', 'YYYY-MM-DD HH24:MI:SS'), 'UPDATE', 'Review', 'reviewer2');

-- ContactAuthor table
INSERT INTO ContactAuthor (paperID, Email) VALUES (PAPER_ID_INCR.NEXTVAL, 'john.smith@example.com');
INSERT INTO ContactAuthor (paperID, Email) VALUES (PAPER_ID_INCR.NEXTVAL, 'alice.cooper@example.com');
INSERT INTO ContactAuthor (paperID, Email) VALUES (PAPER_ID_INCR.NEXTVAL, 'robert.johnson@example.com');
INSERT INTO ContactAuthor (paperID, Email) VALUES (PAPER_ID_INCR.NEXTVAL, 'emily.davis@example.com');
INSERT INTO ContactAuthor (paperID, Email) VALUES (PAPER_ID_INCR.NEXTVAL, 'michael.wilson@example.com');

-- Paper table
INSERT INTO Paper (paperID, Title, FileName, PaperDesc, Submission_Date, Tracks, Status_Field) 
VALUES (1, 'Advancements in Neural Networks', 'neural_networks.pdf', 'This paper presents novel neural network architectures for image recognition.', TO_DATE('2024-02-12','YYYY-MM-DD'), 'AI, Machine Learning', 'Under Review');
INSERT INTO Paper (paperID, Title, FileName, PaperDesc, Submission_Date, Tracks, Status_Field) 
VALUES (2, 'Distributed Database Optimization', 'db_optimization.pdf', 'New techniques for query optimization in distributed database systems.', TO_DATE('2024-02-12','YYYY-MM-DD'), 'Databases', 'Submitted');
INSERT INTO Paper (paperID, Title, FileName, PaperDesc, Submission_Date, Tracks, Status_Field) 
VALUES (3, 'Secure Network Protocols', 'network_security.pdf', 'Enhanced security protocols for wireless networks in IoT environments.', TO_DATE('2024-02-12','YYYY-MM-DD'), 'Security, Networks', 'Under Review');
INSERT INTO Paper (paperID, Title, FileName, PaperDesc, Submission_Date, Tracks, Status_Field) 
VALUES (4, 'AI Applications in Healthcare', 'ai_healthcare.pdf', 'Exploring artificial intelligence applications for medical diagnostics.', TO_DATE('2024-02-12','YYYY-MM-DD'), 'AI, Healthcare', 'Submitted');
INSERT INTO Paper (paperID, Title, FileName, PaperDesc, Submission_Date, Tracks, Status_Field) 
VALUES (5, 'Cloud Resource Management', 'cloud_computing.pdf', 'Efficient resource allocation algorithms for cloud computing infrastructures.', TO_DATE('2024-02-12','YYYY-MM-DD'), 'Cloud Computing', 'Submitted');

-- PaperAuthors table
INSERT INTO PaperAuthors (Author_Email, Paper_ID, AuthorOrder) VALUES ('john.smith@example.com', 1, 1);
INSERT INTO PaperAuthors (Author_Email, Paper_ID, AuthorOrder) VALUES ('sarah.johnson@example.com', 1, 2);
INSERT INTO PaperAuthors (Author_Email, Paper_ID, AuthorOrder) VALUES ('alice.cooper@example.com', 2, 1);
INSERT INTO PaperAuthors (Author_Email, Paper_ID, AuthorOrder) VALUES ('robert.johnson@example.com', 3, 1);
INSERT INTO PaperAuthors (Author_Email, Paper_ID, AuthorOrder) VALUES ('david.brown@example.com', 3, 2);
INSERT INTO PaperAuthors (Author_Email, Paper_ID, AuthorOrder) VALUES ('emily.davis@example.com', 4, 1);
INSERT INTO PaperAuthors (Author_Email, Paper_ID, AuthorOrder) VALUES ('michael.wilson@example.com', 5, 1);
INSERT INTO PaperAuthors (Author_Email, Paper_ID, AuthorOrder) VALUES ('john.smith@example.com', 5, 2);

-- Review table
INSERT INTO Review (reviewID, Submission_Date, Readability, Originality, Relevance, TechnicalMerit, Reviewer_Email, Paper_ID) VALUES (review_seq.NEXTVAL, TO_DATE('2024-04-10','YYYY-MM-DD'), 8, 7, 9, 8, 'reviewer1@university.edu', 1);
INSERT INTO Review (reviewID, Submission_Date, Readability, Originality, Relevance, TechnicalMerit, Reviewer_Email, Paper_ID) VALUES (review_seq.NEXTVAL, TO_DATE('2024-04-10','YYYY-MM-DD'), 7, 6, 8, 7, 'reviewer2@research.org', 1);
INSERT INTO Review (reviewID, Submission_Date, Readability, Originality, Relevance, TechnicalMerit, Reviewer_Email, Paper_ID) VALUES (review_seq.NEXTVAL, TO_DATE('2024-04-10','YYYY-MM-DD'), 9, 8, 8, 9, 'reviewer3@institute.edu', 3);
INSERT INTO Review (reviewID, Submission_Date, Readability, Originality, Relevance, TechnicalMerit, Reviewer_Email, Paper_ID) VALUES (review_seq.NEXTVAL, TO_DATE('2024-04-10','YYYY-MM-DD'), 6, 7, 7, 6, 'reviewer4@university.edu', 3);
INSERT INTO Review (reviewID, Submission_Date, Readability, Originality, Relevance, TechnicalMerit, Reviewer_Email, Paper_ID) VALUES (review_seq.NEXTVAL, TO_DATE('2024-04-10','YYYY-MM-DD'), 8, 9, 8, 8, 'reviewer5@research.org', 5);

-- Create views without depending on triggers
CREATE OR REPLACE VIEW Paper_Status_Report_View AS
SELECT 
    p.paperID,
    p.Title,
    p.Status_Field,
    p.Submission_Date,
    p.Tracks,
    a.First_Name AS Author_Name,
    a.OrganizationInfo AS Author_Organization,
    a.Email AS Author_Email,
    r.First_Name AS Reviewer_Name,
    r.Email AS Reviewer_Email,
    rev.Submission_Date AS Review_Date,
    (rev.Readability + rev.Originality + rev.Relevance + rev.TechnicalMerit)/4 AS Average_Score
FROM 
    Paper p
JOIN 
    PaperAuthors pa ON p.paperID = pa.Paper_ID
JOIN 
    Author a ON pa.Author_Email = a.Email
LEFT JOIN 
    Review rev ON p.paperID = rev.Paper_ID
LEFT JOIN 
    Reviewer r ON rev.Reviewer_Email = r.Email;

CREATE OR REPLACE VIEW Conference_Summary_Report AS
SELECT
    (SELECT COUNT(*) FROM Paper) AS Total_Papers_Submitted,
    (SELECT COUNT(*) FROM Paper WHERE Status_Field = 'Accepted') AS Papers_Accepted,
    (SELECT COUNT(*) FROM Paper WHERE Status_Field = 'Rejected') AS Papers_Rejected,
    (SELECT COUNT(*) FROM Paper WHERE Status_Field = 'Under Review') AS Papers_Under_Review,
    (SELECT COUNT(*) FROM Paper WHERE Status_Field = 'Published') AS Papers_Published,
    ROUND((SELECT COUNT(*) FROM Paper WHERE Status_Field = 'Accepted') / 
          NULLIF((SELECT COUNT(*) FROM Paper), 0) * 100, 2) AS Acceptance_Rate_Percentage
FROM
    DUAL;

-- Commit the changes
COMMIT;

---- After everything is committed, try to create logging procedures instead of triggers
---- These can be used in application code instead of triggers
--CREATE OR REPLACE PROCEDURE log_author_change (
--    p_email VARCHAR2,
--    p_transaction_type VARCHAR2,
--    p_username VARCHAR2
--) AS
--BEGIN
--    INSERT INTO LOGINFO (Transaction_DateTime, TransactionType, Table_Name, Username)
--    VALUES (SYSTIMESTAMP, p_transaction_type, 'Author', p_username);
--EXCEPTION
--    WHEN OTHERS THEN
--        -- Log error
--        INSERT INTO LOGINFO (Transaction_DateTime, TransactionType, Table_Name, Username)
--        VALUES (SYSTIMESTAMP, 'ERROR', 'Author', 'SYSTEM');
--END;
--/
--
--CREATE OR REPLACE PROCEDURE log_paper_state_change (
--    p_paper_id NUMBER,
--    p_old_status VARCHAR2,
--    p_new_status VARCHAR2
--) AS
--    v_username VARCHAR2(50);
--BEGIN
--    IF p_old_status = 'Submitted' AND (p_new_status = 'Accepted' OR p_new_status = 'Rejected') THEN
--        BEGIN
--            SELECT al.Username INTO v_username
--            FROM ContactAuthor ca
--            JOIN AuthorLogin al ON ca.Email = al.Email
--            WHERE ca.paperID = p_paper_id;
--        EXCEPTION
--            WHEN NO_DATA_FOUND THEN
--                v_username := 'SYSTEM';
--        END;
--        
--        INSERT INTO LOGINFO (Transaction_DateTime, TransactionType, Table_Name, Username)
--        VALUES (SYSTIMESTAMP, 'UPDATE', 'Paper', v_username);
--    END IF;
--EXCEPTION
--    WHEN OTHERS THEN
--        INSERT INTO LOGINFO (Transaction_DateTime, TransactionType, Table_Name, Username)
--        VALUES (SYSTIMESTAMP, 'ERROR', 'Paper', 'SYSTEM');
--END;
--/
---- Create triggers that call the procedures
--
---- First drop existing triggers if any
--DROP TRIGGER trg_log_author_changes;
--DROP TRIGGER trg_log_paper_state_change;
--
---- Create trigger for Author changes
--CREATE OR REPLACE TRIGGER trg_log_author_changes
--AFTER INSERT OR UPDATE OR DELETE ON Author
--FOR EACH ROW
--DECLARE
--    v_transaction_type VARCHAR2(50);
--    v_username VARCHAR2(100);
--BEGIN
--    -- Generate username from first and last name (lowercase with no spaces)
--    IF INSERTING OR UPDATING THEN
--        v_username := LOWER(REPLACE(:NEW.First_Name || :NEW.Last_Name, ' ', ''));
--    ELSIF DELETING THEN
--        v_username := LOWER(REPLACE(:OLD.First_Name || :OLD.Last_Name, ' ', ''));
--    END IF;
--    
--    -- Determine transaction type
--    IF INSERTING THEN
--        v_transaction_type := 'INSERT';
--    ELSIF UPDATING THEN
--        v_transaction_type := 'UPDATE';
--    ELSIF DELETING THEN
--        v_transaction_type := 'DELETE';
--    END IF;
--    
--    -- Call the procedure to log the change
--    log_author_change(:NEW.Email, v_transaction_type, v_username);
--END;
--/
--
---- Create trigger for Paper state changes
--CREATE OR REPLACE TRIGGER trg_log_paper_state_change
--AFTER UPDATE OF Status_Field ON Paper
--FOR EACH ROW
--BEGIN
--    -- Call the procedure to log state change
--    log_paper_state_change(:NEW.paperID, :OLD.Status_Field, :NEW.Status_Field);
--END;
--/
-- Create triggers
CREATE OR REPLACE TRIGGER review_auto_increment
BEFORE INSERT ON Review
FOR EACH ROW
BEGIN
    IF :NEW.reviewID IS NULL THEN
        :NEW.reviewID := review_seq.NEXTVAL;
    END IF;
END;
/
CREATE OR REPLACE TRIGGER trg_log_author_changes
AFTER INSERT OR DELETE OR UPDATE ON Author
FOR EACH ROW
DECLARE
    v_transaction_type VARCHAR2(50);
    v_username VARCHAR2(100);
BEGIN
    -- Generate username from first and last name (lowercase with no spaces)
    IF INSERTING OR UPDATING THEN
        v_username := LOWER(REPLACE(:NEW.First_Name || :NEW.Last_Name, ' ', ''));
    ELSIF DELETING THEN
        v_username := LOWER(REPLACE(:OLD.First_Name || :OLD.Last_Name, ' ', ''));
    END IF;
    
    -- Handle the different operations
    IF INSERTING THEN
        v_transaction_type := 'INSERT';
        
        -- Insert into AuthorLogin (combining first+last as username and using author email)
        INSERT INTO AuthorLogin (Username, Email)
        VALUES (v_username, :NEW.Email);
        
        -- Log the transaction
        INSERT INTO LOGINFO (Transaction_DateTime, TransactionType, Table_Name, Username)
        VALUES (SYSTIMESTAMP, v_transaction_type, 'Author', v_username);
        
    ELSIF UPDATING THEN
        v_transaction_type := 'UPDATE';
        
        -- Update AuthorLogin if email changed
        IF :OLD.Email != :NEW.Email THEN
            UPDATE AuthorLogin SET Email = :NEW.Email WHERE Email = :OLD.Email;
        END IF;
        
        -- Log the transaction
        INSERT INTO LOGINFO (Transaction_DateTime, TransactionType, Table_Name, Username)
        VALUES (SYSTIMESTAMP, v_transaction_type, 'Author', v_username);
        
    ELSIF DELETING THEN
        v_transaction_type := 'DELETE';
        
        -- Delete from AuthorLogin first to maintain referential integrity
        DELETE FROM AuthorLogin WHERE Email = :OLD.Email;
        
        -- Log the transaction
        INSERT INTO LOGINFO (Transaction_DateTime, TransactionType, Table_Name, Username)
        VALUES (SYSTIMESTAMP, v_transaction_type, 'Author', v_username);
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        -- Log any errors that occur
        INSERT INTO LOGINFO (Transaction_DateTime, TransactionType, Table_Name, Username)
        VALUES (SYSTIMESTAMP, 'ERROR', 'Author', 'SYSTEM');
END;
/

CREATE OR REPLACE TRIGGER trg_log_paper_state_change
AFTER UPDATE OF Status_Field ON Paper
FOR EACH ROW
WHEN (
    OLD.Status_Field = 'Submitted' AND 
    (NEW.Status_Field = 'Accepted' OR NEW.Status_Field = 'Rejected')
)
DECLARE
    v_username VARCHAR2(50);
BEGIN
    SELECT al.Username INTO v_username
    FROM ContactAuthor ca
    JOIN AuthorLogin al ON ca.Email = al.Email
    WHERE ca.paperID = :NEW.paperID;
    
    INSERT INTO LOGINFO (Transaction_DateTime, TransactionType, Table_Name, Username)
    VALUES (SYSTIMESTAMP, 'UPDATE', 'Paper', v_username);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        INSERT INTO LOGINFO (Transaction_DateTime, TransactionType, Table_Name, Username)
        VALUES (SYSTIMESTAMP, 'UPDATE', 'Paper', 'SYSTEM');
END;
/

INSERT INTO Author (Email, First_Name, Last_Name, OrganizationInfo, Country) VALUES ('john.smitha@example.com', 'John', 'Smiths', 'University of Technology', 'USA');

UPDATE PAPER
SET STATUS_FIELD="Accepted"
WHERE PAPERID=3;

--SELECT * FROM AUTHOR;
--SELECT * FROM AUTHORLOGIN;  //INFO ABOUT AUTHOR
--SELECT * FROM CONTACTAUTHOR;
--SELECT * FROM LOGIN;
SELECT * FROM LOGINFO;
--SELECT * FROM PAPER;
--SELECT * FROM PAPERAUTHORS;
--SELECT * FROM REVIEW;
--SELECT * FROM REVIEWER;
--SELECT * FROM REVIEWERLOGIN;
--SELECT * FROM TOPICSOFINTEREST;