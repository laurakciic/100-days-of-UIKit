# [Project 9 - Grand Central Dispatch](https://www.hackingwithswift.com/100/39)

## Topics

Grand Central Dispatch, PerformSelector, quality of service queues, async()   

<br/>

## Intro

An iPhone XS has six CPU cores inside, and each of those six things can work independently of the others. If you use just one of them – as we have been doing all this time – then your app will never come close to using the full power of the device.
> Apple has a powerful framework called **Grand Central Dispatch** that solves this problem remarkably easy     

<br/>

## About

In this technique project we're going to return to project 7 to solve a critical problem using GCD:

<br/>

_By downloading data from the internet in viewDidLoad() our app will lock up until all the data has been transferred_.   

<br/>

We're going to solve this problem by using GCD, which will allow us to **fetch the data without locking up** the user interface.
> even though GCD might seem easy at first, it opens up a new raft of problems, so be careful!
         
<br/>

## 📒 Field Notes

### What is locking the UI in P7? 

```swift
        if let url = URL(string: urlString) {               // convert to url
            if let data = try? Data(contentsOf: url) {      // fetch from API
                
                parse(json: data)
                return
            }
        }
```

We used Data's contentsOf to download data from the internet on the main thread, which is what's known as a blocking call. That is, it blocks execution of any further code in the method until it has connected to the server and fully downloaded all the data.
> causes the entire program to freeze – the user can touch the screen all they want, but nothing will happen. When the data finally downloads (or just fails), the program will unfreeze. This is a terrible experience, particularly when you consider that iPhones are frequently on poor-quality data connections.  

<br/>
    
### Threads

Threads are code execution processes which execute multiple sets of instructions at the same time, which allows to take advantage of having multiple CPU cores.
> Each CPU can be doing something independently of the others, which hugely boosts your performance.  

<br/>

- Threads execute the code you give them, they don't just randomly execute a few lines from viewDidLoad() each. 
> This means by default your own code executes on only one CPU, because you haven't created threads for other CPUs to work on   

<br/>

- All user interface work must occur on the main thread, which is the initial thread your program is created on. 
> If you try to execute code on a different thread, it might work, it might fail to work, it might cause unexpected results, or it might just crash.   

<br/>

- You don't get to control when threads execute, or in what order. You create them and give them to the system to run, and the system handles executing them as best it can.   

<br/>

-  Because you don't control the execution order, you need to be extra vigilant in your code to ensure only one thread modifies your data at one time.  

<br/>

### Async()

- how you call ```async()``` informs the system where you want the code to run
- GCD works with a system of queues, which are much like a real-world queue, FIFO
> GCD calls don't create threads to run in, they just get assigned to one of the existing threads for GCD to manage

<br/>


GCD creates for you a number of queues, and places tasks in those queues depending on how important you say they are. All are FIFO, meaning that each block of code will be taken off the queue in the order they were put in, but more than one code block can be executed at the same time so the finish order isn't guaranteed.

<br/>


- “how important” some code is depends on something called “quality of service”, or QoS, which decides what level of service this code should be given
    - obviously at the top of this is the main queue, which runs on your main thread, and should be used to schedule any work that must update the user interface immediately even when that means blocking your program from doing anything else

<br/>


### 4 Background Queves

<br/>

_USER INTERACTIVE_
- highest priority background thread
- should be used when you want a background thread to do work that is important to keep your user interface working
- will ask the system to dedicate nearly all available CPU time to you to get the job done as quickly as possible

<br/>


_USER INITIATED_
- to execute tasks requested by the user that they are now waiting for in order to continue using your app
- not as important as user interactive work
    - if the user taps on buttons to do other stuff, that should be executed first – but it is important because you're keeping the user waiting

<br/>


_UTILITY QUEVE_
- for long-running tasks that the user is aware of, but not necessarily desperate for now
- if the user has requested something and can happily leave it running while they do something else with your app

<br/>


_BACKGROUND QUEVE_
- for long-running tasks that the user isn't actively aware of, or at least doesn't care about its progress or when it completes

<br/>

There’s also one more option, which is the _DEFAULT QUEVE_. This is prioritized between user-initiated and utility, and is a good general-purpose choice while you’re learning.

<br/>

Those QoS queues affect the way the system prioritizes your work: User Interactive and User Initiated tasks will be executed as quickly as possible regardless of their effect on battery life, Utility tasks will be executed with a view to keeping power efficiency as high as possible without sacrificing too much performance, whereas Background tasks will be executed with power efficiency as its priority.

<br/>

GCD automatically balances work so that higher priority queues are given more time than lower priority ones, even if that means temporarily delaying a background task because a user interactive task just came in.

<br/>

## 📒 Instructions

### async() method
- takes one parameter, which is a closure to execute asynchronously
> Because async() uses closures, you might think to start with [weak self] in to make sure there aren’t any accident strong reference cycles, but it isn’t necessary here because GCD runs the code once then throws it away – it won’t retain things used inside

1. for making all our [loading code run in the background queue with default quality of service](https://github.com/laurakciic/starting-iOS/commit/e0919b5fb20287cff998d88188d7f7bd28c2e7aa)


