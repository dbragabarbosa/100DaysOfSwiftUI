Project 1, part two

As Immanuel Kant said, “experience without theory is blind, but theory without experience is mere intellectual play.” Yesterday we covered almost all the techniques required to build this app, so now it’s time to turn all that head knowledge into a real, practical app.

One of the things I love about SwiftUI is how easily this transition from theory to practice is – there are no surprises lurking around the corner and no epic extra new things to learn along the way.

Sure, I’ll sneak in a couple of tiny things just to keep you on your toes, but for the most part you already know everything you need to build this project, so now it’s just a matter of seeing how things fit together.

Today you have four topics to work through, in which you’ll apply your knowledge of Form, @State, Picker, and more.



Reading text from the user with TextField

We’re building a check-splitting app, which means users need to be able to enter the cost of their check, how many people are sharing the cost, and how much tip they want to leave.

Hopefully already you can see that means we need to add three @State properties, because there are three pieces of data we’re expecting users to enter into our app.

So, start by adding these three properties to our ContentView struct:

@State private var checkAmount = 0.0
@State private var numberOfPeople = 2
@State private var tipPercentage = 20
As you can see, that gives us a default of 0.0 for the check amount, a default value of 2 for the number of people, and a default value of 20 for the tip percentage. Each of these properties have a sensible default: we don’t know how much the check will come to, but assuming two people and a 20% tip both seem like good starting points for the app.

Of course, some people prefer to leave a different percentage of tip, so we’re going to let them select values from a predetermined array of tip sizes. We need to store the list of possible tip sizes somewhere, so please add this fourth property beneath the previous three:

let tipPercentages = [10, 15, 20, 25, 0]
We’re going to build up the form step by step, starting with a text field where users can enter the value of their check. We’ll start with what you know already, but as you’ll see that won’t quite work right.

Modify the body property to this:

Form {
    Section {
        TextField("Amount", text: $checkAmount)
    }
}
That isn’t going to work, and that’s okay. The problem is that SwiftUI likes TextField to be used for entering text – strings, that is. We could allow that here, but it would mean users could enter any kind of text, and we’d need to carefully convert that string to a number we can work with.

Fortunately, we can do better: we can pass our Double to TextField and ask it to treat the input as a currency, like this:

TextField("Amount", value: $checkAmount, format: .currency(code: "USD"))
That’s an improvement, but we can do even better. You see, that tells SwiftUI we want the currency formatted as US dollars, or USD for short, but given that over 95% of the world’s population don’t use US dollars as their currency we should probably not force “USD” on them.

A better solution is to ask iOS if it can give us the currency code for the current user, if there is one. This might be USD, but it might also be CAD (Canadian dollars), AUD (Australian dollars), JPY (Japanese Yen) and more – or it might not currently have a value, if the user hasn’t set one.

So, a better format to use is this:

.currency(code: Locale.current.currency?.identifier ?? "USD"))
Locale is a massive struct built into iOS that is responsible for storing all the user’s region settings – what calendar they use, how they separate thousands digits in numbers, whether they use the metric system, and more. In our case, we’re asking whether the user has a preferred currency code, and if they don’t we’ll fall back to “USD” so at least we have something.

So far our code creates a scrolling entry form of one section, which in turn contains one row: our text field. When you create text fields in forms, the first parameter is a string that gets used as the placeholder – gray text shown in side the text field, giving users an idea of what should be in there. The second parameter is the two-way binding to our checkAmount property, which means as the user types that property will be updated. The third parameter here is the one that controls the way the text is formatted, making it a currency.

One of the great things about the @State property wrapper is that it automatically watches for changes, and when something happens it will automatically re-invoke the body property. That’s a fancy way of saying it will reload your UI to reflect the changed state, and it’s a fundamental feature of the way SwiftUI works.

To demonstrate this, we could add a second section with a text view showing the value of checkAmount, like this:

Form {
    Section {
        TextField("Amount", value: $checkAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
    }

    Section {
        Text(checkAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
    }
}
That does almost exactly the same thing as our TextField: it asks SwiftUI to format the number as a currency, using either the system default or USD if nothing else is available. Later on in this project we’ll be using a different format style to show percentages – these text formatters are really helpful!

We’ll be making that show something else later on, but for now please run the app in the simulator so you can try it yourself.

Tap on the check amount text field, then enter an example amount such as 50. What you’ll see is that as you type the text view in the second section automatically and immediately reflects your actions.

This synchronization happens because:

Our text field has a two-way binding to the checkAmount property.
The checkAmount property is marked with @State, which automatically watches for changes in the value.
When an @State property changes SwiftUI will re-invoke the body property (i.e., reload our UI)
Therefore the text view will get the updated value of checkAmount.
The final project won’t show checkAmount in that text view, but it’s good enough for now. Before we move on, though, I want to address one important problem: when you tap to enter text into our text field, users see a regular alphabetical keyboard. Sure, they can tap a button on the keyboard to get to the numbers screen, but it’s annoying and not really necessary.

Fortunately, text fields have a modifier that lets us force a different kind of keyboard: keyboardType(). We can give this a parameter specifying the kind of keyboard we want, and in this instance either .numberPad or .decimalPad are good choices. Both of those keyboards will show the digits 0 through 9 for users to tap on, but .decimalPad also shows a decimal point so users can enter check amount like $32.50 rather than just whole numbers.

So, modify your text field to this:

TextField("Amount", value: $checkAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
    .keyboardType(.decimalPad)
You’ll notice I added a line break before .keyboardType and also indented it one level deeper than TextField – that isn’t required, but it can help you keep track of which modifiers apply to which views.

Go ahead and run the app now and you should find you can now only type numbers into the text field.

Tip: The .numberPad and .decimalPad keyboard types tell SwiftUI to show the digits 0 through 9 and optionally also the decimal point, but that doesn’t stop users from entering other values. For example, if they have a hardware keyboard they can type what they like, and if they copy some text from elsewhere they’ll be able to paste that into the text field no matter what is inside that text. That’s OK, though – the text field will automatically filter out bad values when they hit Return.



Creating pickers in a form

SwiftUI’s pickers serve multiple purposes, and exactly how they look depends on which device you’re using and the context where the picker is used.

In our project we have a form asking users to enter how much their check came to, and we want to add a picker to that so they can select how many people will share the check.

Pickers, like text fields, need a two-way binding to a property so they can track their value. We already made an @State property for this purpose, called numberOfPeople, so our next job is to loop over all the numbers from 2 through to 99 and show them inside a picker.

Modify the first section in your form to include a picker, like this:

Section {
    TextField("Amount", value: $checkAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
        .keyboardType(.decimalPad)

    Picker("Number of people", selection: $numberOfPeople) {
        ForEach(2..<100) {
            Text("\($0) people")
        }
    }
}
Now run the program in the simulator and try it out – what do you notice?

Hopefully you spot several things:

There’s a new row that says “Number of people” on the left and “4 people” on the right.
There’s are two gray arrows on the right edge, which is the iOS way of signaling that tapping the row shows a menu of options.
The row says “4 people”, but we gave our numberOfPeople property a default value of 2.
So, it’s a bit of “two steps forward, two steps back” – we have a nice result, but it doesn’t work and doesn’t show the right information!

We’ll fix both of those, starting with the easy one: why does it say 4 people when we gave numberOfPeople the default value of 2? Well, when creating the picker we used a ForEach view like this:

ForEach(2 ..< 100) {
That counts from 2 up to 100, creating rows. What that means is that our 0th row – the first that is created – contains “2 People”, so when we gave numberOfPeople the value of 2 we were actually setting it to the third row, which is “4 People”.

So, although it’s a bit brain-bending, the fact that our UI shows “4 people” rather than “2 people” isn’t a bug.

Pickers come with lots alternative styles depending on how you want things to behave. For example, later we'll use a segmented style for the tip percentage picker, which is a good fit because it doesn't have many options.

One popular picker style is called navigation link, which moves the user to a new screen to select their option. To try it here, add the .pickerStyle(.navigationLink) modifier to your picker, like this:

Picker("Number of people", selection: $numberOfPeople) {
    ForEach(2 ..< 100) {
        Text("\($0) people")
    }
}
.pickerStyle(.navigationLink)
That won't quite work as expected, though. This time you'll see a gray disclosure indicator on the right edge, but the whole row will be grayed out – it won't show anything when tapped.

What SwiftUI wants to do – which is also why it’s added the gray disclosure indicator on the right edge of the row – is show a new view with the options from our picker.

To do that, we need to add a navigation stack, which does two things: gives us some space across the top to place a title, and also lets iOS slide in new views as needed.

So, directly before the form add NavigationStack {, and after the form’s closing brace add another closing brace. If you got it right, your code should look like this:

var body: some View {
    NavigationStack {
        Form {
            // everything inside your form
        }
    }
}
If you run the app again you’ll see that tapping on the Number Of People row makes a new screen slide in with all the other possible options to choose from.

You should see that “4 People” has a checkmark next to it because it’s the selected value, but you can also tap a different number instead – the screen will automatically slide away again, taking the user back to the previous screen with their new selection.

What you’re seeing here is the importance of what’s called declarative user interface design. This means we say what we want rather than say how it should be done. We said we wanted a navigation link picker with some values inside, but we didn't have to say "now create a list of all our items, showing a checkmark to whichever is selected right now."

Do you prefer the menu picker, or the navigation link picker? It's your app – you get to choose! I'm going to go with the menu picker as that's the default, but please go with whatever you prefer.

Before we’re done with this step, let’s add a title to that new navigation bar. Give the form this modifier:

.navigationTitle("WeSplit")
Tip: It’s tempting to think that modifier should be attached to the end of the NavigationStack, but it needs to be attached to the end of the Form instead. The reason is that navigation stacks are capable of showing many views as your program runs, so by attaching the title to the thing inside the navigation stack we’re allowing iOS to change titles freely.



Adding a segmented control for tip percentages

Now we’re going to add a second picker view to our app, but this time we want something slightly different: we want a segmented control. This is a specialized kind of picker that shows a handful of options in a horizontal list, and it works great when you have only a small selection to choose from.

Our form already has two sections: one for the amount and number of people, and one where we’ll show the final result – it’s just showing checkAmount for now, but we’re going to fix it soon.

In the middle of those two sections I’d like you to add a third to show tip percentages:

Section {
    Picker("Tip percentage", selection: $tipPercentage) {
        ForEach(tipPercentages, id: \.self) {
            Text($0, format: .percent)
        }
    }
}
That loops over all the options in our tipPercentages array, converting each one into a text view with the .percent format. Just like the previous picker, SwiftUI will convert that to a single row in our list, and present a pop-up menu of options when it’s tapped.

Here, though, I want to show you how to use a segmented control instead, because it looks much better. So, please add this modifier to the tip picker:

.pickerStyle(.segmented)
That should go at the end of the picker’s closing brace, like this:

Section {
    Picker("Tip percentage", selection: $tipPercentage) {
        ForEach(tipPercentages, id: \.self) {
            Text($0, format: .percent)
        }
    }
    .pickerStyle(.segmented)
}
If you run the program now you’ll see things are starting to come together: users can now enter the amount on their check, select the number of people, and select how much tip they want to leave – not bad!

But things aren’t quite what you think. One problem app developers face is that we take for granted that our app does what we intended it to do – we designed it to solve a particular problem, so we automatically know what everything means.

Try to look at our user interface with fresh eyes, if you can:

“Amount” makes sense – it’s a box users can type a number into.
“Number of people” is also pretty self-explanatory.
The label at the bottom is where we’ll show the total, so right now we can ignore that.
That middle section, though – what are those percentages for?
Yes, we know they are to select how much tip to leave, but that isn’t obvious on the screen. We can – and should do better.

One option is to add another text view directly before the segmented control, which we could do like this:

Section {
    Text("How much tip do you want to leave?")

    Picker("Tip percentage", selection: $tipPercentage) {
        ForEach(tipPercentages, id: \.self) {
            Text($0, format: .percent)
        }
    }
    .pickerStyle(.segmented)
}
That works OK, but it doesn’t look great – it looks like it’s an item all by itself, rather than a label for the segmented control.

A much better idea is to modify the section itself: SwiftUI lets us add views to the header and footer of a section, which in this instance we can use to add a small explanatory prompt. In fact, we can use the same text we just created, just moved to be the section header rather than a loose label inside it.

Here’s how that looks in code:

Section("How much tip do you want to leave?") {
    Picker("Tip percentage", selection: $tipPercentage) {
        ForEach(tipPercentages, id: \.self) {
            Text($0, format: .percent)
        }
    }
    .pickerStyle(.segmented)
}
It’s a small change to the code, but I think the end result looks a lot better – the text now looks like a prompt for the segmented control directly below it.



Calculating the total per person

So far the final section in our form has shown a simple text view with whatever check amount the user entered, but now it’s time for the important part of this project: we want that text view to show how much each person needs to contribute to the payment.

There are a few ways we could solve this, but the easiest one also happens to be the cleanest one, by which I mean it gives us code that is clear and easy to understand: we’re going to add a computed property that calculates the total.

This needs to do a small amount of mathematics: the total amount payable per person is equal to the value of the order, plus the tip percentage, divided by the number of people.

But before we can get to that point, we first need to pull out the values for how many people there are, what the tip percentage is, and the value of the order. That might sound easy, but as you’ve already seen, numberOfPeople is off by 2 – when it stores the value 3 it means 5 people.

So, we’re going to create a new computed property called totalPerPerson that will be a Double, and it will start off by getting the input data ready: what is the correct number of people, and how much tip do they want to leave?

First, add the computed property itself, just before the body property:

var totalPerPerson: Double {
    // calculate the total per person here
    return 0
}
That sends back 0 so your code doesn’t break, but we’re going to replace the // calculate the total per person here comment with our calculations.

Next, we can figure out how many people there are by reading numberOfPeople and adding 2 to it. Remember, this thing has the range 2 to 100, but it counts from 0, which is why we need to add the 2.

So, start by replacing // calculate the total per person here with this:

let peopleCount = Double(numberOfPeople + 2)
You’ll notice that converts the resulting value to a Double because it needs to be used alongside the checkAmount.

For the same reason, we also need to convert our tip percentage into a Double:

let tipSelection = Double(tipPercentage)
Now that we have our input values, it’s time do our mathematics. This takes another three steps:

We can calculate the tip value by dividing checkAmount by 100 and multiplying by tipSelection.
We can calculate the grand total of the check by adding the tip value to checkAmount.
We can figure out the amount per person by dividing the grand total by peopleCount.
Once that’s done, we can return the amount per person and we’re done.

Replace return 0 in the property with this:

let tipValue = checkAmount / 100 * tipSelection
let grandTotal = checkAmount + tipValue
let amountPerPerson = grandTotal / peopleCount

return amountPerPerson
If you’ve followed everything correctly your code should look like this:

var totalPerPerson: Double {
    let peopleCount = Double(numberOfPeople + 2)
    let tipSelection = Double(tipPercentage)

    let tipValue = checkAmount / 100 * tipSelection
    let grandTotal = checkAmount + tipValue
    let amountPerPerson = grandTotal / peopleCount

    return amountPerPerson
}
Now that totalPerPerson gives us the correct value, we can change the final section in our table so it shows the correct text.

Replace this:

Section {
    Text(checkAmount, format: .currency(code: Locale.current.currencyCode ?? "USD"))
}
With this:

Section {
    Text(totalPerPerson, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
}
Try running the app now, and see what you think. You should find that because all the values that make up our total are marked with @State, changing any of them will cause the total to be recalculated automatically.

Hopefully you’re now seeing for yourself what it means that SwiftUI’s views are a function of their state – when the state changes, the views automatically update to match.



Hiding the keyboard

We’re now almost at the end of our project, but you might have spotted an annoyance: once the keyboard appears for the check amount entry, it never goes away!

This is a problem with the decimal and number keypads, because the regular alphabetic keyboard has a return key on there to dismiss the keyboard. However, with a little extra work we can fix this:

We need to give SwiftUI some way of determining whether the check amount box should currently have focus – should be receiving text input from the user.
We need to add some kind of button to remove that focus when the user wants, which will in turn cause the keyboard to go away.
To solve the first one you need to meet your second property wrapper: @FocusState. This is exactly like a regular @State property, except it’s specifically designed to handle input focus in our UI.

Add this new property to ContentView:

@FocusState private var amountIsFocused: Bool
Now we can attach that to our text field, so that when the text field is focused amountIsFocused is true, otherwise it’s false. Add this modifier to your TextField:

.focused($amountIsFocused)
That’s the first part of our problem solved: although we can’t see anything different on the screen, SwiftUI is at least silently aware of whether the text field should have focus or not.

The second part of our solution is to add a toolbar button when the text field is active. To make this work really well you need to meet several new SwiftUI views, so I think the best thing to do is show you the code then explain what it does.

Add this new modifier to your form, below the existing navigationTitle() modifier:

.toolbar {
    if amountIsFocused {
        Button("Done") {
            amountIsFocused = false
        }
    }
}
Let’s break it down:

The toolbar() modifier lets us specify toolbar items for a view. These toolbar items might appear in various places on the screen – in the navigation bar at the top, in a special toolbar area at the bottom, and so on.
The condition checks whether amountIsFocused is currently true, so we only show the button when the text field is active.
The Button view we’re using here displays some tappable text, which in our case is “Done”. We also need to provide it with some code to run when the button is pressed, which in our case sets amountIsFocused to false so that the keyboard is dismissed.
You’ll meet these more in the future, but for now I recommend you run the program and try it out – it’s a big improvement!

That was the last step in this project – pat yourself on the back, because we’re finished!