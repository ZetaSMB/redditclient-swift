# Reddit Client - Swift

A sample Reddit client that shows the top 50 entries from [Reddit](https://github.com/deviget/iOS-Test/blob/master/www.reddit.com/top)

#### Pre-requisites to run the project
* Xcode 10.2.1 and later
* Swift 5 and later

# Architecture and guidelines
The code follows an MVP architectural pattern approach, and the guidelines:

    - Assume the latest platform and use Swift
    - Use UITableView / UICollectionView to arrange the data.
    - Please refrain from using any dependency manager [cocoapods / carthage / etc], instead, use URLSession 
    - Support all Device Orientation
    - Support all Devices screen (iPhone/iPad)
    - Use Storyboards

# Included milestones 
	
	- Show each entry such as: title, author, entry date (following a format like “x hours ago”), thumbnail, number of comments, unread status
    - Pull to Refresh
    - Pagination support
    - Indicator of unread/read post (updated status, after post it’s selected)
    - Dismiss Post Button (remove the cell from list. Animations required)
    - Dismiss All Button (remove all posts. Animations required)
    - Support split layout (left side: all posts / right side: detail post)
	- Preserve already read items status on refresh 
	- In addition, for those having a picture (besides the thumbnail), please allow the user to tap on the thumbnail to be sent to the full sized picture. You don’t have to implement the IMGUR API, so just opening the URL would be OK.
	- Saving pictures in the picture gallery

# Pending milestones 
    
    - App state-preservation/restoration
