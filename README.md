# crave_aosp_builder

[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[forks-shield]: https://img.shields.io/github/forks/sounddrill31/crave_aosp_builder?style=for-the-badge
[forks-url]: https://github.com/sounddrill31/crave_aosp_builder/network/members
[stars-shield]: https://img.shields.io/github/stars/sounddrill31/crave_aosp_builder.svg?style=for-the-badge
[stars-url]: https://github.com/sounddrill31/crave_aosp_builder/stargazers

Please avoid importing, or "kanging" this repository as it is frequently updated.

This ensured you can easily update to the latest changes and also boosts my fork stats 😉

>[!WARNING]
> I have received reports that people are getting their Actions access restricted upon using this, especially new accounts.
> When they tried contacting github support, they got a "In particular, any repositories that use GitHub Actions solely to interact with 3rd party websites, to engage in incentivized activities, or for general computing purposes may fall afoul of the GitHub Additional Product Terms". More explanation follows.

When I take a look at [Additional Product Terms for Actions](https://docs.github.com/en/site-policy/github-terms/github-terms-for-additional-products-and-features#actions), I do not see anything directly disbarring this activity. (as of 28th January 2025)
1. Potential explanation 1:
    - These users may have been using github runners instead of the selfhostable ones
    - "If using GitHub-hosted runners, any other activity unrelated to the production, testing, deployment, or publication of the software project associated with the repository where GitHub Actions are used."
2. Potential explanation 2:
     - "Any activity that places a burden on our servers, where that burden is disproportionate to the benefits provided to users (for example, don't use Actions as a content delivery network or as part of a serverless application, but a low benefit Action could be ok if it’s also low burden)"
    - This just connects to a 3rd party service to offload heavy computational tasks out there.
    - The intention of this repo is to decrease this burden from github servers, to disincentivise people from trying to abuse CI services like this to build android or other high storage/computationally heavy projects.
    - We have explicit consent(even encouragement) from the Crave.io team to set this up w.r.t. using their services to make usage easier.

**Neither of these are the same thing as what is mentioned in the response.** 

If you are a github employee and do not like what we're doing, please open an issue and I will disable this repo with a notice asap. If you would like to discuss a better option, again, just please open an issue. 

>[!WARNING]
> You have been warned about using this repo, especially non-selfhosted workflows. While I cannot find anything that we're violating among the given terms, policies, etc, I am not a lawyer.

>[!WARNING]
> Feb 2025 Update: I've disabled non selfhosted runners on this repo after yet another user brought this to my attention. Use self-hosted workflow to avoid github actions bans against your account.
## Wiki
While using this repo, please take a look at [the wiki](https://fosson.top/crave/) as well!

## Prerequisites 
foss.crave.io account

This workflow assumes you know basics of android building and github actions. Please read the Readme thoroughly before asking questions.

## Setup Instructions
- Download crave.conf from API Keys of foss.crave.io dashboard
- Fork this repo(please avoid importing it via the import menu or manually copying the workflow file. This hurts fork stats and makes it harder for you to update the repo to the latest version)
- Go to (repo) Settings -> Security -> Secrets and Variables -> Actions
- Copy your username and authentication token from crave.conf
![Repository Secrets](assets/cravetoken.png)

- Create a Repository Secret called CRAVE_USERNAME, with username from crave.conf
- Create a Repository Secret called CRAVE_TOKEN, with authentication token from crave.conf
![Repository Secrets](assets/secrets.png)
![Repository Secrets](assets/secrets2.png)

- Go to Settings -> Code and Automation -> Actions -> General
- Set workflow Permissions to "Read and Write Permissions" and save.
    - If this permission is greyed out and you're building from a Github Organization,
        - go to Organization settings -> Code, planning, and automation -> Actions -> General -> Workflow permissions, set it to "Read and Write Permissions" and save

- Now you are ready to build! Go to "Crave Builder" workflow and start building
## Selfhosted Runners:
These runners sit in crave devspace CLI or your personal server and run the workflow on there. Use this if you need to bypass the 6 hours timeout limit.

## Extra Setup For Selfhosted runner:
- Follow the above steps
- On the top menu bar of the repository, click on Actions
- Self-Hosted Runner -> New Runner
![Self Hosted Runners](assets/runners.png)
- Scroll down and copy the Runner Token(avoid closing this tab till the process is done)
![Finding Runner Token](assets/token-1.png)

- Go back to Actions, select "Create Selfhosted Runner"
- Run Workflow and enter your Runner token.
Ensure you have no random spaces before or after
![Using Runner token](assets/token-2.png)

- Start the workflow
- After this is done, you are ready to build! Go to the "Crave Builder(self-hosted)" workflow and start building

(If the runner is offline still, trigger "Start/Restart Selfhosted Runner" workflow to force-restart the selfhosted runner)

## Required Secrets
### CRAVE_USERNAME (Required)
This is the email you signed up to crave with 

example: 
```
person@example.com
```
### CRAVE_TOKEN (Required)
This is the Authorization part of the crave.conf. It should not contain `:`, spaces, or `,`

![CRAVE_TOKEN](assets/cravetoken.png)
### CUSTOM_YAML (Optional)
If this exists, the crave.yaml will be overridden while running the workflow

example:
```
CipherOS:
  ignoreClientHostname: true
Arrow OS:
  ignoreClientHostname: true
DerpFest-aosp:
  ignoreClientHostname: true
LOS 20:
  ignoreClientHostname: true
LOS 21:
  ignoreClientHostname: true
```

For more info, read the documentation [here](https://foss.crave.io/docs/crave-usage/#location-of-the-craveyaml-file)
### EXTRA_FILES (Optional)
If this exists, these files will be uploaded too. Remember to use relative path like out/target/product/devicename/file.something and seperate multiple files with spaces.
### TELEGRAM_TOKEN (Optional)
Bot token for telegram notifications
### TELEGRAM_TO (Optional)
Chat id for telegram notifications
### CRAVE_FLAGS (Optional)
Extra flags for crave binary
### TG_UPLOAD_LIMIT (Optional)
Custom Upload limit for telegram-upload. Default is 2147483648
### GH_UPLOAD_LIMIT (Optional)
Custom Upload limit for github releases. Default is 2147483648
### DISPLAY_FALSE (Optional)
This workflow displays your local manifests by default. To disable this, create this secret with any data

## Inputs Explanation
### Base Project
- These are the projects everyone can build, with a foss.crave.io account
- These are the ones officially added
### Repo init Command
- This is only for when you are initializing another ROM. When doing this, ensure you are initializing on top of closest cousin base project
- Don't initialize android 14 on top of android 13 projects
- If you just type 'skip', it will skip the compilation. This is useful for uploading and debugging
### Removals
- When we resync another ROM on top, we are bound to get "cannot checkout" errors. To fix this, we add that folder to the Removals tab
- Add a space after .repo/local_manifests and add these folders. Don't change if you don't need to
- Almost defunct now, since /opt/crave/resync.sh script on crave handles everything for us
### Local Manifest
- Here you enter the git repo and branch for your local manifests, containing device specific repositories. These will be cloned to .repo/local_manifests
### Device Details
- Enter the device codename you want to build for inside DEVICE_NAME, like "oxygen".
- Enter the device codename inside PRODUCT_NAME, to be inserted into the breakfast command. If you enter makefile name(without the .mk, like "lineage_oxygen"), it will fallback to using the lunch command.
- If the project is RisingOS and no changes have been made, breakfast becomes riseup. If makefile name is detected, it falls back to lunch 
- For devices with '_' (underscores) in the target, please report them [here](https://github.com/sounddrill31/crave_aosp_builder/discussions/44) so I can add support for them

### Build Command
- eg. m updatepackage, mka bacon, make recoveryimage
### Build Type
- Choose the build type
    - user:  Limited access; suited for production

    - userdebug:  Like user but with root access and debug capability; very close to production performance

    - eng:  Development configuration with faster build time; most suited for day-to-day development
### Clean Build
- Uses fresh Base Project sources without any of your changes(use only for testing/debugging)

## Known Issues
- You Tell Me :)
## Extra Info
- For scheduled builds, it's better to remove the workflow dispatch stuff, check [lineage_builder](https://github.com/a57y17lte-dev/lineage_builder) for reference.
- This Repo is a spiritual successor to azwhikaru's Action-TWRP-Builder
## Credits!
- [AntoninoScordino](https://github.com/AntoninoScordino) for the recent rewrite
- [azwhikaru's Action-TWRP-Builder](https://github.com/azwhikaru/Action-TWRP-Builder) Which I used as reference
- [My Manifest tester](https://github.com/sounddrill31/Manifest_Tester) (credits to [AmogOS](https://github.com/AmogOS-Rom) project for original logic)
- [Other contributors](https://github.com/sounddrill31/crave_aosp_builder/graphs/contributors)
- [The crave team](https://github.com/accupara) for the build servers and helping us out when we get stuck

## FAQs:

### Signup

Q1. What is this Crave.io? How do I get an account?

A. Crave.io is a build accelerator capable of cutting down build time by quite a bit. They are providing free build servers, however: self signup is disabled. 

Please fill out the [form](https://forms.gle/Jhvy9osvdmcS9B7fA) if you're looking for an account. for more info, check the [wiki](https://fosson.top/crave/getting-started/introduction#getting-an-account)


### Chat Help
Q2. Hey, I get an error with this repository! Whom do i ask?

A. Please feel free to contact me through the [crave.io discord](https://discord.crave.io) or [ROM Builders telegram](https://t.me/ROM_builders) if this repo isn't working as expected(please avoid pinging me while asking about rom building issues unrelated to this repository). My username is `sounddrill`


### Unsupported ROMs
Q3. This doesn't support XXnewrom2024XX! How do I build it?

A. [Read this](#repo-init-command)

Here, we enter our repo init command for a non-supported ROM. If we are building something that's supported by crave, we can leave the default as is. 

Doing this is not recommended and is known to be troublesome. However, it doesn't break any crave rules yet. 

### Paid Queue

To use your crave wallet with one of these projects, just set a secret called "PAID" without the quotes with any data(like "true")

To know more about wallets, read this: 

https://fosson.top/crave/getting-started/more-info.html#paid-queue

https://foss.crave.io/docs/wallets/


### Build Signing
Q4. How do I sign my builds?

A. Build signing can be done using Backblaze B2 Buckets to hold the private keys. 

> [!WARNING]
> This method is deprecated for now with no better alternative other than using crave push. If you figure something out and want to contribute, please contact me or make a PR.

Follow [this](https://fosson.top/crave/getting-started/build-signing.html#signing-builds-on-crave) guide to generate, encrypt and upload your keys to Backblaze.

Create a actions secret called CUSTOM_YAML with the correct credentials as your environment variables. If this secret is set, the workflow will use this for crave.yaml, instead of the templates found in config/crave folder of this repository. 

```
LOS 21:
  ignoreClientHostname: true
  env:
    BUCKET_NAME: your_bucket_name
    KEY_ENCRYPTION_PASSWORD: your_key_encryption_password
    BKEY_ID: your_bkey_id
    BAPP_KEY: your_bapp_key
```

Replace "LOS 21" with your base project's name. Remember to use the correct name, get it from `crave clone list`.

Also remember to replace the placeholder credentials with actual values.

It is also recommended to set ignoreClientHostname to preserve workflow persistence. Read more about it [here](https://fosson.top/crave/getting-started/more-info.html#workspace-persistence).

Steps:
- Go to (repo) Settings -> Security -> Secrets and Variables -> Actions
- Set repository secret called CUSTOM_YAML
- Enter the contents of your crave.yaml from above

While building: 
- Replace 'mka bacon' in the build command section of the workflow dispatch to:

```
mka target-files-package otatools; /opt/crave/crave_sign.sh
```

## Star History

<a href="https://star-history.com/#sounddrill31/crave_aosp_builder&Date">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=sounddrill31/crave_aosp_builder&type=Date&theme=dark" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=sounddrill31/crave_aosp_builder&type=Date" />
   <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=sounddrill31/crave_aosp_builder&type=Date" />
 </picture>
</a>
