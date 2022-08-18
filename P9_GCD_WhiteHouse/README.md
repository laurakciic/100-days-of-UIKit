# [Project 9 - Grand Central Dispatch](https://www.hackingwithswift.com/100/39)

## Topics

Grand Central Dispatch, PerformSelector, quality of service queues, async()   

<br/><br/>    

## Intro

An iPhone XS has six CPU cores inside, and each of those six things can work independently of the others. If you use just one of them – as we have been doing all this time – then your app will never come close to using the full power of the device.
> Apple has a powerful framework called **Grand Central Dispatch** that solves this problem remarkably easy     

<br/><br/>
## About

In this technique project we're going to return to project 7 to solve a critical problem using GCD:
<br/><br/>
_By downloading data from the internet in viewDidLoad() our app will lock up until all the data has been transferred_.
<br/><br/>
We're going to solve this problem by using GCD, which will allow us to **fetch the data without locking up** the user interface.
> even though GCD might seem easy at first, it opens up a new raft of problems, so be careful!
         
      
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

<br/><br/>
<br/><br/>
    
### Threads

Threads are code execution processes which execute multiple sets of instructions at the same time, which allows to take advantage of having multiple CPU cores.
> Each CPU can be doing something independently of the others, which hugely boosts your performance.

- Threads execute the code you give them, they don't just randomly execute a few lines from viewDidLoad() each. 
> This means by default your own code executes on only one CPU, because you haven't created threads for other CPUs to work on

- All user interface work must occur on the main thread, which is the initial thread your program is created on. 
> If you try to execute code on a different thread, it might work, it might fail to work, it might cause unexpected results, or it might just crash.

- You don't get to control when threads execute, or in what order. You create them and give them to the system to run, and the system handles executing them as best it can.

-  Because you don't control the execution order, you need to be extra vigilant in your code to ensure only one thread modifies your data at one time.




