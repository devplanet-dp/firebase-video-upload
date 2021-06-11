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
2. Certificate handling
3. Building app
4. Uploading app to TestFlight
5. Automating Screenshots
6. Releasing app

## Creating your app with Fastlane

Before creating the app you need to provide your Apple ID in Appfile insde fastlane. By setting this, fastlane won's ask it repeatedly. Opend **Appfile** and remove `#` sign against **apple_id** field. You can fill **app_identifier** field once you created the app. If somehow your App Store Connect and Apple Developer portal usernames are differennt, replace the **apple_id** line with:
```
apple_dev_portal_id("[[APPLE_DEVELOPER_ACCOUNT_USERNAME]]")
itunes_connect_id("[[APP_STORE_CONNECT_ACCOUNT_USERNAME]]")
```

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

## Code signing with match

Fastlane [match](https://docs.fastlane.tools/actions/match/) will give you a smart way of sharing certifcate accros your development team. It will keep all required certificates & provisioning profiles in an encrypted storage. It supports **git repository, Google Cloud, or Amazon S3**.This tutorial use private git repository on Github. 

Open Terminal and execute:
```
fastlane match init
```

this will prompt to select storage type. Select your desired storgae type and enter the URL to the storage. 

![match init](https://i.imgur.com/XhQWoar.png)

match will asks for password for certificate encryption. Once you proceed with a password certificates will be handled by fastlane match. To create profiles for development and App Store you can execute following commands:
```
fastlane match development
fastlane match appstore
```
Once completed go to Apple Developer portal. You will see profiles are created there:

![match profiles](https://i.imgur.com/zJ3yExb.png)

As you know the code sigining is managing by the fastlane match, so you need to disable the automatic code sigining in XCode project. You can also add a lane to sync certificates on the machine. Open **Fastfile** and add following configuration:
```
desc "Sync certificates"
  lane :sync_profiles do
    #read-only disable match from overriding the existing certificates.
    match(readonly: true)
  end
```
## Two-factor authentication with Fastlane

Fastlane currenlty supports [Two-factor authentication for Apple ID](https://support.apple.com/en-us/HT204915) for sigining to apple developer account. But when you need to upload a build to App Store or TestFlight you need to use **App-specific** password. Apple enables to sign in to your account for third-party apps with your Apple ID using app-specific passwords. You can generate a **App-specific** password by visiting your [apple account](appleid.apple.com/account/manage)

![Generate App-Specific](https://i.imgur.com/EB2X3xx.png)

But you know that It's painful to deal with 2FA when comes to continuoes delivery. So the fastlane has implemented an authentication usingApp Store Connect API. It is the **recommended** to use API Key  when you are able to. However currently it doesn't support for all of the fastlane actions. Check out [App Store Connect API](https://docs.fastlane.tools/app-store-connect-api/) for more information


## Build IPA file with Gym

Archive and building the is time-consuming. But with fastlane you have [gym](https://docs.fastlane.tools/actions/gym/).It takes care of generaring a signed `ipa` file. 
In Terminal execute:

``fastlane gym init``

Then fastlane will create a **Gymfile** for you. Open the **Gymfile** and add following scipt.

```
# App scheme name
scheme("ToDo")
#provide provisioning profiles to use
export_options({
    method: "app-store",
    provisioningProfiles: { 
      "com.devplanet.todo" => "match AppStore com.devplanet.todo",
         }
})
# specify the path to store .ipa file
output_directory("./fastlane/builds")
# Excludes bitcode from the build
include_bitcode(false)
# Excludes symbols from the build.
include_symbols(false)

```
You many need to build .ipa for different purposes such as **appstore, adhoc, enterprise or development**. You need to update provisioning profile type inside **Matchfile** as requuired. Here is example for **appstore** build.

```
git_url("https://github.com/devplanet-dp/match_todo.git")

storage_mode("git")

type("appstore") # The default type, can be: appstore, adhoc, enterprise or development
```

You know that when building the app for release , always you need to increment version number. So to automate versioning you need to enable Apple Generic Versioning in your project. You can enable it by changing app versioning settings as below:
![Enable Apple Generic versioning](https://i.imgur.com/8W72mZo.png)

Now open the **Fastfile** file and add the below lane to create `ipa`.

```
desc "Create ipa"
  lane :build do
    #uddate profiles
    sync_profiles
    # Increases the build number by 1
    increment_build_number
    # Creates a signed file
    gym
  end
```

Then run **build** in Terminal

```
fastlane build
```
Note that before building the app you need to disable Automatically code siging and select the correct **Provisioning profile** in XCode.

![Manual code sigining](https://i.imgur.com/22bMaPl.png)

Fastlane will ask your keychain password if the specific apple ID is not given access to your certificate before. Once you get the message that build is completed you can find `ipa` file in `fastlabe/builds` directoy. How cool and fast is that right?.

## Upload to TestFlight with Pilot

Fastlane supports TestFlight too. It uses [pilot](https://docs.fastlane.tools/actions/pilot/) to manage your app on TestFlight. Only you need is to add another lane inside **Fastfile**. As you have already a lane to build `ipa` file, only you need is the **pilot** command to be added to **Fastfile**. 

```desc "Upload to TestFlight"
  lane :beta do
    build
    pilot  
  end
end
```
Once the process started fastlane may ask for your **App-specific** password. You can generate one as mentioned above in this tutorial and use it in here to complete the operatiosn. If you need to upload a specific `ipa` file to testfilght, please remove `build` from lane and add `ipa("./fastlane/builds/ToDo.ipa”)`. This will upload `ipa` inside the file path. 

Once fastlane completed the process, please go to App Store connect, you can see the build is availble in **TestFlight**. 

![Imgur](https://i.imgur.com/prA5vJ9.png)

You can add new tester to the app using the command `fastlane pilot add email@invite.com -g group-1,group-2`. There are many configurations you can find on [pilot](https://docs.fastlane.tools/actions/pilot).

## Fastlane Screenshots

App Store screenshots takes major part in app release. You can make theme by a tool or take reals screen on running app. This takes lot of efrort when comes to screenshots with different resolutions. How if you can automate it by running a single command. In order to take screenshots you need to have a UI test. To create UI test you can record steps using XCode and it will automatically generates codes in your test method. To learn more, check this [article](https://developer.apple.com/library/archive/documentation/ToolsLanguages/Conceptual/Xcode_Overview/RecordingUITests.html).

When the UI test is ready run the following command:
```
fastlane snapshot init
```
Once comleted you can see the steps to generate screenshot.Go to newly **Snapfile** inside **fastlane** and configure it as your requirenment. You can only use list of available simulators in your XCode. 

```
# A list of devices you want to take the screenshots from
 devices([
   "iPhone 8",
   "iPhone 8 Plus",
   "iPad Pro (12.9-inch)",
   "iPad Pro (9.7-inch)",
#   "Apple TV 1080p"
])

 languages([
   "en-US",
#   "de-DE",
#   "it-IT",
#   ["pt", "pt_BR"] # Portuguese with Brazilian locale
 ])

# The name of the scheme which contains the UI Tests
scheme("ToDoUITests")

# Where should the resulting screenshots be stored?
 output_directory("./screenshots")

# remove the '#' to clear all previously generated screenshots before creating new ones
 clear_previous_screenshots(true)

```
Now open the Xcode and drag and drop **SnapshotHelper.swift** file into your UI test directory. You can choose the options as below:

![Adding SnapshotHelper file](https://i.imgur.com/Cn4Hyks.png)

Now open your **ToDoUITests.swift** (your app test file), and add `setupSnapshot(app)` before `app.laucch()`. Whenever you need to capture the screen add `snapshot("0screenName")`.

Next you have to add UITest target as a XCode scheme. To do that go **Product>Scheme>Manage Schemes..**. Inside **Manage Schemes** add your UITest target as below. 

![Manage Schemes](https://i.imgur.com/TkiKVBp.png)

Make sure to enable **shared** property. Double tap on UI Test scheme and click **Build** on the scheme editor. Then select **Test** and **Run** options and close the window. 

![Edit UI Test scheme](https://i.imgur.com/jpZKtvc.png)

Now XCode configurations are completed. Now you can move to adding a lane to **Fastfile**. Add following lane. This lane uses **snapshot** to take screenshots as per **Snapfile**'s settings.

```
desc "Take screenshots"
  lane :screenshot do
    snapshot
  end
```

Now run the command `fastlane screenshot` command in your Terminal. Once fastlane completes the process an HTML will open automatically with preview of screenshots. How cool is that right?.

![Preview screenshot](https://i.imgur.com/E4u1T1f.png)

## Fastlane deliver

As in the fastlane docs "[deliver](https://docs.fastlane.tools/actions/deliver/) uploads screenshots, metadata and binaries to App Store Connect. Use deliver to submit your app for App Store review". Go inside your root directory of the project and enter:
```
fastlane deliver
```

Once you press `y` after the message `No deliver configuration found in the current directory. Do you want to setup deliver?`, It will ask you `Would you like to use Swift instead of Ruby? (y/n)`. I prefer to go with **Ruby** because **fastlane.swift** is still in beta. So press `n` and proceed with **Ruby**. Once the deliverfile generation completed you can find new files created inside fastlane directory of your project. 
- **metadata**: contains App Store Connect metadata.
- **screenshot**: contains the app screenshot.
- **deliverfile**: contains some other metadata required for App Store release.

You can easliy understand the metadata text file becuase they are named by App Store seaction names. You can modify these files by adding your app information. fastlane will use them to submit information to App Store. 

Additionally you can provide a app's ratting file. You need to create a JSON file inside metadata directory named **app_store_rating_config.json** containing:
```
{
  "CARTOON_FANTASY_VIOLENCE": 0,
  "REALISTIC_VIOLENCE": 0,
  "PROLONGED_GRAPHIC_SADISTIC_REALISTIC_VIOLENCE": 0,
  "PROFANITY_CRUDE_HUMOR": 0,
  "MATURE_SUGGESTIVE": 0,
  "HORROR": 0,
  "MEDICAL_TREATMENT_INFO": 0,
  "ALCOHOL_TOBACCO_DRUGS": 0,
  "GAMBLING": 0,
  "SEXUAL_CONTENT_NUDITY": 0,
  "GRAPHIC_SEXUAL_CONTENT_NUDITY": 0,
  "UNRESTRICTED_WEB_ACCESS": 0,
  "GAMBLING_CONTESTS": 0
}
```

This fil gives apple the information to calculate app's age ratting.

## Releasing to the App Store Connect

Now you have .ipa file, metadata and screenshots waiting to upload to the App Store Connect. You need to modify **Deliverfile** with content below. 

```
# indicating it’s a free app.
price_tier(0)
# Answer the questions Apple would present to you upon manually submitting for review
submission_information({
    export_compliance_encryption_updated: false,
    export_compliance_uses_encryption: false,
    content_rights_contains_third_party_content: false,
    add_id_info_uses_idfa: false
})
# 3
app_rating_config_path("./fastlane/metadata/app_store_rating_config.json")
# file location
ipa("./fastlane/builds/ToDo.ipa”)
# automatically submit the app for review(In my case false)
submit_for_review(false)
# 6
automatic_release(false)
```
You can add this **Fastfile** as lane:

```
desc "Upload to App Store"
  lane :upload do
    deliver
  end
 ```

All done! Now on Terminal execute the command to upload:

```
fastlane uplaod
```

Fastlane will verifying the upload via the HTML file. If everything looks perfect you can proceed else terminate uploading process and update the deliverfiles.

Once the lane is completed, have a visit to App Store Connect. You can see the build is uploaded and waiting for review.

![App Store Connect](https://i.imgur.com/hvrT4gE.png)

You can also combine all the lanes we created above. So a single command will Create app, take screenshots, build and upload to App Store

Open **Fastfile** and put all the lanes together. 

```
desc "Create app, screenshot ,build and upload"
  lane :release_app do
    create_app
    build
    screenshot	
    deliver
  end
```

Now you can just run `fastlane release_app` and fast lane will take care of everything.

Finally you can check your fastlane setup by running `fastlane` command in your Terminal. You'll see list of available lanes. 

![Fastlane setup](https://i.imgur.com/e47PLzC.png)

## Conclusion

In this tutorial you built a Pipeline for iOS development workflows using **fastlane**. It adds value to your regular iOS development workflow by saving hours of time that you have spended on building, testing and releasing apps. You can make your iOS automation task more advanced and suited for your exact needs when you become comfortable with it. 

If you are interested in other ways to handle this and get more idea, check out [official documentation](https://fastlane.tools). Hopfully you got an idea on how you could automate your next iOS project.
