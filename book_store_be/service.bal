import ballerina/http;
import ballerina/time;
// import ballerina/io;

type Book record {|
    readonly int id;
    string title;
    string author;
|};

type NewBook record {|
    string title;
    string author;
|};

isolated table<Book> key(id) books = table [
    {id: 1, title: "1984", author: "George Orwell"},
    {id: 2, title: "To Kill a Mockingbird", author: "Harper Lee"}
];

type ErrorDetails record {
    string message;
    string details;
    time:Utc timestamp;
};

type BookNotFound record {|
    *http:NotFound;
    ErrorDetails body;
|};

@http:ServiceConfig {
    cors: {
        allowOrigins: ["*"], 
        allowHeaders: ["Content-Type"]   ,
        allowMethods: ["GET", "POST", "DELETE", "OPTIONS"]   
    }
}
service / on new http:Listener(8080) {
    isolated resource function get books() returns Book[] {
        lock {
            return books.toArray().cloneReadOnly();
        }
    }

    isolated resource function get books/[int id]() returns Book|BookNotFound {
        lock {
            Book? book = books[id];
            if book is () {
                BookNotFound bookNotFound = {
                    body: {message: string `id: ${id}`, details: string `books/${id}`, timestamp: time:utcNow()}
                };
                return bookNotFound.cloneReadOnly();
            }
            return book.cloneReadOnly();
        }
    }

    resource function post books(NewBook book) returns http:Created|error {
        lock {
            // sort the books by id
            Book[] sorted= from var e in books order by e.id ascending select e;
            // foreach var item in sorted {
            //     io:println(item.id," ", item.author);
            // }
            // get the last id from sorted list
            var lastId = sorted[sorted.length() - 1].id;
            books.add({id: lastId+1, ...book.cloneReadOnly()});
            return http:CREATED;
        }
    }

    resource function delete books/[int id]() returns Book|BookNotFound {
        lock {
            Book? book = books[id];
            if book is () {
                BookNotFound bookNotFound = {
                    body: {message: string `id: ${id}`, details: string `books/${id}`, timestamp: time:utcNow()}
                };
                return bookNotFound.cloneReadOnly();
            }
            // remove the book from the table
            _ = books.remove(id);
            return book.cloneReadOnly();
        }
    }
}

