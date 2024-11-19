# Some Random Notes

Clone a whole bunch of repos. You can add filters and limit switches to gh.

`gh repo list jimweller --json name | jq -r '.[].name' | xargs -I {} gh repo clone jimweller/{}`
