## Log urls inspector - test challenge

This CLI application accepts path to file as an argument and outputs to STDOUT:
- list of webpages with most page views ordered from most page views to less page views.      
- list of webpages with most unique page views ordered the same.       

In case the program encounters errors in a line of input - message about this errors is sent to STDERR, but
it does not terminate the application, it will still analyze valid lines.

## Usage: 
```
git clone git@github.com:mechos3d/log_parser_test.git log_parser
cd log_parser
./bin/log_parser  ./spec/fixtures/webserver.log
```

## TODOs:
( What I would improve/change if I'd continue to work on the app )

1 The application should output only 'most page views' OR 'most unique page views' (but not both simultaneously). 
  Remove the unnecessary titles from the output. 
  The list or urls must be easily machine-readable and must provide the ability to be easily piped to some other application's input.
  What kind of sorting to use - must be controlled by a flag passed to the application like this: 
  ```
  # this outputs urls sorted by all views:
  ./bin/log_parser -v some_file

  # this outputs urls sorted by only unique views:
  ./bin/log_parser -u some_file
  ```

2 There's a TODO in `./lib/log_parser/cli_entrypoint.rb` that need to be fixed. 
  It's a bad pratice that a method named 'invalid_input_error_code' which must only determine the error_code, 
  has an unexpected side-effect of printing to $stderr.

3 Considering that urls from the file are printed to the users terminal 'as is' - we need to implement validation of
  characters in the urls to prevent unsafe characters. 

4 Every CLI application should implement a `--help / -h` flag showing it's documentation.


