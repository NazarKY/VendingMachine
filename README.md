#### To start app run: `make`
#### To run tests: `make test`

## VendingMachine

* **Negotiator** - some kind of interface with which the User interacts
* **Validator** - valid User inputs
* **Order** - model of Order
* **VendingMachine** - the core of app, that connects all app parts


## TODO
1. Implement the Product Class. With Service for managing Product State
2. Implement a Service for managing the Payment Process. 
    * Currently Existed Change is taken from "inserted money" - coins only.  But I do not do subtraction of the Given(to User) Change from the Existed Change. I mean, I do only add to Existed Change - without subtraction from it `(but currently it's not an issues because of item #3)` 
3. Do not stop app execution after successful order close. Better to start a new iteration for the next order
4. Add tests which would cover interaction with User. For reading from console input
5. ...
