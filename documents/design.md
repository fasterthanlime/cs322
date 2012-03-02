# Design considerations


## Entity-Relationship schema

* `college`, `league` must live on their own because we have to search on them
* `height` can be coerced into one real value (metric or imperial)
* `ilkid` is to a player what a `coachid` is to a coach
* all the `*_career` files are denormalized data that we may be able to recalculate from the dataset

### Files

You will find the `er.dia` file in the design subdirectory. It's been made using
[Dia](https://live.gnome.org/Dia) (GTK+ apps aren't super nice on OSX/Windows but it's _Libre_ software my friend).
