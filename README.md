# How to Build the Perfect fastlane Pipeline for iOS

You've been spending months into building apps, and finally when come to the distribution it is not an easy task. Many individual steps need to be performed, capturing screenshots for most of the major screen sizes, configuring your app with Apple Developer and App Store Connect, uploading build and many more. 

How if you could run a single command that take care of all these.  Imagine how it will save your time and reduce complexity. Yes! you can achieve it with 
app automation tool called [Fastlane!](https://fastlane.tools). 

In this tutorial you will learn how to build a local fastlane pipeline that will automate and simplify development steps like signining, testing, building and deploying stages for a simple ToDo Application. It's all done on your local environment. 

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

You can also install fastlane using brew. Just run the `brew install fastlane` in your terminal. After running the commands you can see installation progress in Terminal. This could take several minutes. When the intallation completes confim the installation by running following command:
 ```
 fastlane --version
 ```
It will show you output like this
```
 fastlane installation at path:
/usr/local/Cellar/fastlane/2.185.0/libexec/gems/fastlane-2.185.0/bin/fastlane
-----------------------------
[✔] 🚀 
fastlane 2.185.0
```
Congratulations!, you're ready to use fastlane in your project. 

## Configuring fastlane with your project

This tutorial uses simple app called ToDo to show possibilites of fastlane. You need to have a paid Apple Developer account to complete this. Now create a simple app in Xcode. 

![Create iOS project](https://i.imgur.com/WDB66y6.png)

To initialize fastlane inside the project go to root of the project directory from Terminal and run the following command
```
fastlane init
```
Then you will see some output like this. 

![Init fastlane](https://i.imgur.com/iNgmcTL.png)

Fastlane will ask to choose a single automated action to implement. But you'll implement multiple automated actions on this tutorial. So just select manual setup by entering **4**. 
Once selected it will output some guidlines on how to use Fastlane with the project.

Go to root directory of the project, you will see **Gemfile** which is added as a project dependency and a fastlane directory containing:

* **Appfile** : file contains bundle identifier and your Apple ID.
* **Fastfile** : file contains the fastlane.tools configuration and actions. 

## Fastlane lanes

A lane is a workflow of sequential task. Lane has a description and name where you can execute these lanes with the name on command line. In this tutorial you will create lanes for:

1. Creating app in Apple Developer Portal and App Store Connect. 
2. Automanting screenshots
3. Testing
4. Building app
5. Uploading app to App Store
6. Releasing

## Creating your app with Fastlane

Before creating the app you need to provide your Apple ID in Appfile insde fastlane. By setting this, fastlane won's ask it repeatedly. Opend **Appfile** and remove `#` sign against **apple_id** field. You can fill **app_identifier** field once you created the app. If somehow your App Store Connect and Apple Developer portal usernames are differennt, replace the **apple_id** line with:
```
apple_dev_portal_id("[[APPLE_DEVELOPER_ACCOUNT_USERNAME]]")
itunes_connect_id("[[APP_STORE_CONNECT_ACCOUNT_USERNAME]]")
```
---authenticating apple services---
You can use fastlane CredentialManager to add credentials to the keychain. This will disable asking you credentials everytime. Execute the following command:
```
fastlane fastlane-credentials add --username [APPLE_ID]
Password: *********
Credential felix@krausefx.com:********* added to keychain.
```

Then you can move to adding a lane inside **Fastfile**. Open **Fastfile** and then replace it with the content below and save the file. 
```
default_platform(:ios)

platform :ios do
  desc "Create app on Apple Developer and App Store Connect"
  lane :create_app do
    produce  
  end
end
```
You have now created your first **lane**. To run the lane open the Terminal inside your project folder and execute:
```
fastlane create_app
```
This command will prompt to enter the App Store connect password. In case you have multiple teams associated with Developer portal you can select desired team. 
Fastlane supports supports [Two-factor authentication for Apple ID](https://support.apple.com/en-us/HT204915) you may see a message like below:
```
Two-factor Authentication (6 digits code) is enabled for account '********@gmail.com'
More information about Two-factor Authentication: https://support.apple.com/en-us/HT204915

If you're running this in a non-interactive session (e.g. server or CI)
check out https://github.com/fastlane/fastlane/tree/master/spaceship#2-step-verification

Please enter the 6 digit code you received at +45 •• •• •• 42:
```
 Once all this produce will ask to enter apps's bundle ID. Bundle ID should be a unique one which is not previously used in App Store. 
 
 ![Create bundle id](https://i.imgur.com/byAfTx7.png)

Then fastlane will ask to submit a app name. App name shoudn't be more than 30 characters and need to be unique.

Go to the Apple Developer Portal and App Store connect. Then you see the magic. Your app has been created there. 

![Apple Developer Portal](https://i.imgur.com/0UoM1Zn.png)

![App Store Connect](https://i.imgur.com/1OyhXFh.png)

Now you can go ahead and add the bundle ID which you created to **app_identifier** property in **Appfile**.

## Fastlane deliver

As fastlane describes "[deliver](https://docs.fastlane.tools/actions/deliver/) uploads screenshots, metadata and binaries to App Store Connect. Use deliver to submit your app for App Store review". Go inside your root directory of the project and enter:
```
fastlane deliver
```

Once you press `y` after the message `No deliver configuration found in the current directory. Do you want to setup deliver?`, It will ask you `Would you like to use Swift instead of Ruby? (y/n)`. I prefer to go with **Ruby** because **fastlane.swift** is still in beta. So press `n` and proceed with **Ruby**. Once the deliverfile generation completed you can find new files created inside fastlane directory of your project. 
- **metadata**: contains App Store Connect metadata.
- **screenshot**: contains the app screenshot.
- **deliverfile**: contains some other metadata required for App Store release.

You can easliy understand the metadata text file becuase they are named by App Store seaction names. You can modify these files by adding your app information. fastlane will use them to submit information to App Store. 

- 

