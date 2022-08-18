# [Project 9 - Grand Central Dispatch](https://www.hackingwithswift.com/100/39)

## Topics

Grand Central Dispatch, PerformSelector, quality of service queues

## Intro

An iPhone XS has six CPU cores inside, and each of those six things can work independently of the others. If you use just one of them – as we have been doing all this time – then your app will never come close to using the full power of the device.
> Apple has a powerful framework called **Grand Central Dispatch** that solves this problem remarkably easy

## About

In this technique project we're going to return to project 7 to solve a critical problem using GCD:
_By downloading data from the internet in viewDidLoad() our app will lock up until all the data has been transferred_.

We're going to solve this problem by using GCD, which will allow us to **fetch the data without locking up** the user interface.
> even though GCD might seem easy at first, it opens up a new raft of problems, so be careful!
