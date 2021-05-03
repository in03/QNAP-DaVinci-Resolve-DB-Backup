# Hey!

If you're here, it's because you have the niche need of frequently backing up your DaVinci Resolve PostgreSQL database that runs on your QNAP NAS. Maybe like me, you use the collaborative editing feature, which unfortunately, is not compatible with project backups. For whatever reason, backing up the whole database at regular automatic intervals is a none too shabby idea. I threw this collection of *poorly written* scripts together to work in the very specific environment. QNAP runs busybox Linux, has very few Linux tools and no external package support out of the box. Adding it is a pain. It doesn't take kindly to running custom scripts. Anything foreign is deleted from the filesystem upon reboot. The series of steps to get this working on your system are daunting. And it may not even work on your system! QNAP may change the rules in a firmware update... I tell you this because there's a better solution:

Install Container Station on your QNAP NAS.
Do yourself a favour and install Portainer to manage your running containers better.
Run this container (substituing variables. Read the README): https://github.com/prodrigestivill/docker-postgres-backup-local. 
It literally does exactly what my script does without running in the dangerous waters of QNAP's native, murky Linux ecosystem.
Done! 

# There's a catch #
The container's time is set to UTC by default. This means for me (AEST), 2pm is actually 12:00am, when I want my backups to start. You can do the maths and account for the mismatched timezones. That was good enough for me. If it isn't for you, feel free to submit a pull request with a timezone environment variable implemented to the above repo.

# Conclusion #
Basically, only use my script if your QNAP NAS doesn't support running containers.
Even then, this repo was my first foray into shell scripting.
I know it's spaghetti, and I know most of the variables and filenames are half CamelCase and snake_case.
I work an awkward split of javascript and python and I couldn't remember what shell scripting favoured.
