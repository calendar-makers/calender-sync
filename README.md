# Links
* Gmail: naturecalendar2016@gmail.com
* Google Drive: https://drive.google.com/drive/u/1/folders/0B9mZP8ngprxbVDM2ZWhGZEdyMjQ
* Cloud9: https://ide.c9.io/naturecalendar/nature-calendar
* GitHub: https://github.com/Nature-in-the-City/Nature_Calendar/
* Heroku: https://nature-calendar.herokuapp.com/
* Pivotal Tracker: https://www.pivotaltracker.com/n/projects/1540479/
* Code Climate: https://codeclimate.com/github/Nature-in-the-City/Nature_Calendar/
* [![Code Climate](https://codeclimate.com/github/Nature-in-the-City/Nature_Calendar/badges/gpa.svg)](https://codeclimate.com/github/Nature-in-the-City/Nature_Calendar)
* [![Test Coverage](https://codeclimate.com/github/Nature-in-the-City/Nature_Calendar/badges/coverage.svg)](https://codeclimate.com/github/Nature-in-the-City/Nature_Calendar/coverage)
* [![Issue Count](https://codeclimate.com/github/Nature-in-the-City/Nature_Calendar/badges/issue_count.svg)](https://codeclimate.com/github/Nature-in-the-City/Nature_Calendar)
* Travis CI: https://travis-ci.org/Nature-in-the-City/Nature_Calendar/
* [![Build Status](https://travis-ci.org/Nature-in-the-City/Nature_Calendar.svg?branch=master)](https://travis-ci.org/Nature-in-the-City/Nature_Calendar)
* YouTube: https://youtu.be/Sb__EmK319k

# Setup
Assuming you are using Cloud 9 and have run the CS 169 setup script:
```
curl -fsSL c9setup.saasbook.info | bash --login && rvm use 2.2.2 --default
```
Make sure you are using Ruby 2.2.3 and have webkit-capybara installed. Then clone this repository and set up Rails and Heroku. (See instructions below.)

### ruby 2.2.3 installation
```
rvm install ruby-2.2.3
gem update --system
update_rubygems
gem install bundler
```

### webkit-capybara installation
```
sudo add-apt-repository ppa:canonical-qt5-edgers/qt5-proper -y (ignore the errors)
sudo add-apt-repository ppa:ubuntu-sdk-team/ppa -y (ignore the errors)
sudo apt-get update
sudo apt-get install qtcreator libqtwebkit-dev qt5-default libqt5webkit5-dev gstreamer1.0-plugins-base gstreamer1.0-tools gstreamer1.0-x -y
```

### Rails
```
git clone https://github.com/Nature-in-the-City/Nature_Calendar.git
cd Nature_Calendar
echo "export MEETUP_API=5a33782e51306c72532c33283d7d148" >> ~/.profile
bundle install --without production
bundle exec rake db:migrate db:seed db:test:prepare
xvfb-run -a bundle exec rake cucumber
xvfb-run -a bundle exec rake spec
rails s -p $PORT -b $IP
```

### Heroku
```
(heroku create nature-calendar)
(heroku config:set MEETUP_API=5a33782e51306c72532c33283d7d148)
git remote add heroku https://git.heroku.com/nature-calendar.git
git push heroku master
heroku run rake db:migrate db:seed
heroku open
```

### Grading
```
git checkout iterationi-j-sp16
bundle install --without production
bundle exec rake db:migrate db:test:prepare db:seed
xvfb-run -a bundle exec rake cucumber
xvfb-run -a bundle exec rake spec
```

# Purpose
Nature in the City's mission is to inspire San Francisco to discover local nature.

# History
We were founded in 2005 and work with all ages in San Francisco on habitat restoration, environmental education, and building healthy communities. In 2007, we started the Green Hairstreak Corridor to restore habitat for a locally threatened butterfly, and today the butterfly population is strong. We currently care for 14 public habitat restoration gardens in a roughly 28 square block neighborhood area. We also work in public gardens with volunteers at Adah's Stairway and conserve open space and as well as serve as an environmental education resource throughout San Francisco.

# Goals
The goal of this project is to have a calendar application that displays San Francisco nature events for multiple partner agencies, who can, as users, insert their event information -- so that multiple agency information can be added, edited, and displayed on multiple websites. The problem it addresses is to fix bugs that developed with the last CS 169 calendar sync project and to make the application user friendly and viewable by partner organizations to reach larger audiences. The existing project the students engineered for us can be found here: https://github.com/calendar-makers/calendar-sync

# Key Features
The key features include a simplified user experience, an API that continues to sync with meetup.com, and can also be edited by partners and communicate event details to our partner organizations.

# Devices
Mobile phones, Tablets, Desktops

# Target Audience
The target audience for this project is San Francisco and regional audiences wishing to experience outdoors and local nature events. We estimate the audience being from 1000 to 5000 people annually.

# Why
Making our events and partner events accessible to the public is a time-consuming, often manual process, and we wish to integrate other groups to expand offerings and reach new audiences.
