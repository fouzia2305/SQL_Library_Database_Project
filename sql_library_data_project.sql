 -- Create the 'library' database
 create database library;
 
 -- Switch to the 'library' database
 use library;
 
 -- View the contents of the 'publisher' ,'library branch','borrower','books', 'book loans','book copies','authors' tables
 SELECT * FROM publisher;
 SELECT * FROM `library branch`;
 SELECT * FROM borrower;
 SELECT * FROM books;
 SELECT * FROM `book loans`;
 SELECT * FROM `book copies`;
SELECT * FROM authors; 
 
 
 -- Renaming a column in  'authors', 'book loans','book copies','books','library branch' tables
 alter table authors
 rename column ï»¿book_authors_BookID to book_authors_BookID;
 
 alter table `book loans`
 rename column ï»¿book_loans_BookID to book_loans_BookID;
 
 alter table `book copies`
 rename column ï»¿book_copies_BookID to book_copies_BookID;
 
 alter table books
rename column ï»¿book_BookID to book_BookID;
 
 alter table `library branch`
 add column library_branch_BranchID tinyint primary key auto_increment;
 
 -- How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"?
 select b.book_Title,lb.library_branch_BranchName,c.book_copies_No_Of_Copies
 from books b
 join `book copies` c on b.book_BookID=c.book_copies_BookID
 join `library branch` lb on c.book_copies_BranchID=lb.library_branch_BranchID
 where b.book_Title='The Lost Tribe' and lb.library_branch_BranchName='Sharpstown';

-- How many copies of the book titled "The Lost Tribe" are owned by each library branch?
select lb.library_branch_BranchName, SUM(c.book_copies_No_Of_Copies) AS total_copies 
 from books b
 join `book copies` c on b.book_BookID=c.book_copies_BookID
 join `library branch` lb on c.book_copies_BranchID=lb.library_branch_BranchID
 where b.book_Title='The Lost Tribe' 
 GROUP BY lb.library_branch_BranchName;
 
-- Retrieve the names of all borrowers who do not have any books checked out.
select br.borrower_BorrowerName, br.borrower_BorrowerAddress
from borrower br
where not exists (
    select 1
    from `book loans` bl
    where bl.book_loans_CardNo = br.borrower_CardNo
);
-- For each book that is loaned out from the "Sharpstown" branch and whose DueDate is 2/3/18, retrieve the book title, the borrower's name, and the borrower's address. 
select b.book_Title, br.borrower_BorrowerName, br.borrower_BorrowerAddress,bl.book_loans_DueDate
from `book loans` bl
join books b on bl.book_loans_BookID = b.book_BookID
join borrower br on bl.book_loans_CardNo = br.borrower_CardNo
join `library branch` lb on bl.book_loans_BranchID = lb.library_branch_BranchID
where lb.library_branch_BranchName = 'Sharpstown' 
and str_to_date(book_loans_DueDate, '%m/%d/%y') = '2018-02-03';


-- For each library branch, retrieve the branch name and the total number of books loaned out from that branch.
select lb.library_branch_BranchName,count(book_loans_BranchID) as total_books_loaned
from `book loans` bl
join `library branch` lb on bl.book_loans_BranchID = lb.library_branch_BranchID
GROUP BY lb.library_branch_BranchName;

-- Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books checked out.
select  br.borrower_CardNo,br.borrower_BorrowerName, br.borrower_BorrowerAddress,COUNT(bl.book_loans_BookID) AS total_books_checked_out
from  borrower br
join `book loans` bl on br.borrower_CardNo = bl.book_loans_CardNo
GROUP BY br.borrower_CardNo,br.borrower_BorrowerName,br.borrower_BorrowerAddress
having COUNT(bl.book_loans_BookID) > 5;

-- For each book authored by "Stephen King", retrieve the title and the number of copies owned by the library branch whose name is "Central".
select b.book_Title,lb.library_branch_BranchName, bc.book_copies_No_Of_Copies
from books b
join authors a on b.book_BookID = a.book_authors_BookID
join `book copies` bc on b.book_BookID = bc.book_copies_BookID
join `library branch` lb on bc.book_copies_BranchID = lb.library_branch_BranchID
where a.book_authors_AuthorName = 'Stephen King' 
and lb.library_branch_BranchName = 'Central';



