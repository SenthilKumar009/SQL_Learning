use db_LibraryManagement;

select * from dbo.tbl_book;
select * from dbo.tbl_book_copies;
select * from tbl_library_branch;

/* #1- How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"? */

select br.library_branch_BranchName as BranchName, bc.book_copies_No_Of_Copies as TotalBooks
from tbl_library_branch br, tbl_book_copies bc, tbl_book bk
where bc.book_copies_BookID = bk.book_BookID
and br.library_branch_BranchID = bc.book_copies_BranchID
and br.library_branch_BranchName = 'Sharpstown' and bk.book_Title = 'The Lost Tribe';

/* #2- How many copies of the book titled "The Lost Tribe" are owned by each library branch? */

select br.library_branch_BranchID as BranchID, br.library_branch_BranchName as BranchName,bk.book_Title BookTitle, bc.book_copies_No_Of_Copies as TotalBooks
from tbl_book bk
inner join tbl_book_copies bc on bc.book_copies_BookID = bk.book_BookID
inner join  tbl_library_branch br on br.library_branch_BranchID = bc.book_copies_BranchID
where bk.book_Title = 'The Lost Tribe';

/* #3- Retrieve the names of all borrowers who do not have any books checked out. */

select * from tbl_book_loans;
select * from tbl_borrower