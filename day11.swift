Structs, part two

As you’ve seen, structs let us combine individual pieces of data to make something new, then attach methods so we can manipulate that data.

Today you’re going to learn about some of the more advanced features of structs that make them more powerful, including static properties and access control
– the art of stopping other parts of your code from meddling in places they ought not to be.

There’s a famous quote that is sadly anonymous, but I think it fits well here: “privacy is power – what people don’t know, they can’t ruin.” 
As you’ll see, the same is true in Swift: hiding access to certain properties and methods can actually make our code better, because there are fewer places 
able to access it.

As a reminder, both of these things are used extensively in SwiftUI, so it’s worth taking the time to master them now because they’ll be in use from our 
very first project onwards.



How to limit access to internal data using access control

By default, Swift’s structs let us access their properties and methods freely, but often that isn’t what you want – sometimes you want to hide some data 
from external access. For example, maybe you have some logic you need to apply before touching your properties, or maybe you know that some methods need 
to be called in a certain way or order, and so shouldn’t be touched externally.

We can demonstrate the problem with an example struct:

struct BankAccount {
    var funds = 0

    mutating func deposit(amount: Int) {
        funds += amount
    }

    mutating func withdraw(amount: Int) -> Bool {
        if funds >= amount {
            funds -= amount
            return true
        } else {
            return false
        }
    }
}

That has methods to deposit and withdraw money from a bank account, and should be used like this:

var account = BankAccount()
account.deposit(amount: 100)
let success = account.withdraw(amount: 200)

if success {
    print("Withdrew money successfully")
} else {
    print("Failed to get the money")
}

But the funds property is just exposed to us externally, so what’s stopping us from touching it directly? The answer is nothing at all – this kind of code 
is allowed:

account.funds -= 1000
That completely bypasses the logic we put in place to stop people taking out more money than they have, and now our program could behave in weird ways.

To solve this, we can tell Swift that funds should be accessible only inside the struct – by methods that belong to the struct, as well as any computed 
properties, property observers, and so on.

This takes only one extra word:

private var funds = 0
And now accessing funds from outside the struct isn’t possible, but it is possible inside both deposit() and withdraw(). If you try to read or write funds 
from outside the struct Swift will refuse to build your code.

This is called access control, because it controls how a struct’s properties and methods can be accessed from outside the struct.

Swift provides us with several options, but when you’re learning you’ll only need a handful:

Use private for “don’t let anything outside the struct use this.”
Use fileprivate for “don’t let anything outside the current file use this.”
Use public for “let anyone, anywhere use this.”

There’s one extra option that is sometimes useful for learners, which is this: private(set). This means “let anyone read this property, but only let my 
methods write it.” If we had used that with BankAccount, it would mean we could print account.funds outside of the struct, but only deposit() and withdraw() 
could actually change the value.

In this case, I think private(set) is the best choice for funds: you can read the current bank account balance at any time, but you can’t change it without 
running through my logic.

If you think about it, access control is really about limiting what you and other developers on your team are able to do – and that’s sensible! If we can 
make Swift itself stop us from making mistakes, that’s always a smart move.

Important: If you use private access control for one or more properties, chances are you’ll need to create your own initializer.