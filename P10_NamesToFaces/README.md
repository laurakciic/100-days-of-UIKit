# [Project 10 - Grand Central Dispatch](https://www.hackingwithswift.com/100/39)

## Topics

UICollectionViewController, UIImagePickerController, Data, UUID, UIImagePickerController, NSObject, CALayer

<br/>

## Intro



<br/>

## About

An app to help store names of people you've met.

<br/>

## 📒 Field Notes


```swift

```


## 📒 Project


<br/>

## 💡 Challenges


<br/>

## 📝 Facts from quiz

- UICollectionViewController contains a UICollectionView inside it, but adds other functionality on top
- The path property of a URL gives us the location as a string
> It's helpful for APIs that use a string for the filename rather than a URL

<br/>

- UIImagePickerController lets us read photos from the user's photo library & let us take photos using the camera
- We can create UIImage from anywhere that has image data, such as our app's documents directory
- Data can hold any kind of binary data
> It might be a zip file, it might be a JPEG, or it might just be a string stored as binary data

<br/>

- Each app has its own documents directory
> It's stored in a location we can't guess, so we need to read it using FileManager

<br/>

- Collection view items are referenced using section and item rather than section and row
> Collection views work as grids by default, so they don't have a concept of "rows"

<br/>

- When dequeueing a custom collection view cell we need to typecast it to our specific type
> UIKit gives us back a general UICollectionViewCell, but we know it's actually our custom type so we need to use ```as``` or ```as?``` to convert it

<br/>

- CALayer can add borders and round corners of views
> Every UIView has a layer property that we can manipulate in this way

<br/>

- Classes don't need a custom initializer if their properties are given initial values somewhere, for example if we give them default values
- We can force a UICollectionView to reload all its data by calling its reloadData() method.
> This works just the same as with UITableView

<br/>

- UUID stands for Universally Unique Identifier
