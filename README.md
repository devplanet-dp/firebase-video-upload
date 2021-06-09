# How to Build the Perfect fastlane Pipeline for iOS

You've been spending months into building apps, and finally when come to the distribution it is not an easy task. Many individual steps need to be performed, capturing screenshots for most of the major screen sizes, configuring your app with Apple Developer and App Store Connect, uploading build and many more. 

How if you could run a single command that take care of all these.  Imagine how it will save your time and reduce complexity. Yes! you can achieve it with 
app automation tool called [Fastlane!](https://fastlane.tools). 

In this tutorial you will learn how to build a local fastlane pipeline that will automate and simplify development steps like signining, testing, building and deploying stages for a simple Hello World Application. It's all done on your local environment. 

## Why Fastlane?

Fastlane is an app automation framework ------

## Setting Up fastlane

There are many wauys if installing fastlane. I am using Ruby for the task as fastlane is a collection of **Ruby scripts**. You must have Ruby install in your machine. You can simply confirm it ny opening Terminal and running:
```
ruby -v
```
If Ruby is not installed you can do it by [Homebrew](https://brew.sh). 
```
/bin/bash -c “$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
Just confim the installation by running the command:
```
brew --version
```
If all things working perfectly , install Ruby using:
```
brew update && brew install ruby
```

Next step is setup the **XCode command-line tool(CLT)**. It can be enabled with following command: 
```
xcode-select --install
```
If CLT are already installed, you will get a message `xcode-select: error: command line tools are already installed, use "Software Update" to install updates`

Now you're ready to install fastlane. So Run the following command:

```
sudo gem install -n /usr/local/bin fastlane --verbose
```

You can also install fastlane using brew:
```
brew install fastlane
```
 You can confim the installation by running following command:
 ```
 fastlane --version
 ```
 
 After running these commands you can see installation progress in Terminal. This could take several minutes.
 
 Once the installation is completed, you're ready to use fastlane in your project. 


