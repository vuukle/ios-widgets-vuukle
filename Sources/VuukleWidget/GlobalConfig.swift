//
//  GlobalConfig.swift
//  VukkleExample
//
//  Created by Narek Dallakyan on 11/19/20.
//  Copyright © 2020 MAC_7. All rights reserved.
//

import Foundation

enum VuukleConstants: String {

    case httpUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 12_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Mobile/15E148 Safari/12.1.2"

    case vuukleIframe = "https://cdn.vuukle.com/amp.html?url=https%3A%2F%2Fwww.prowrestling.com%2Fimpact-wrestling-results-1282020%2F&host=prowrestling.com&id=1196371&apiKey=46489985-43ef-48ed-9bfd-61971e6af217&img=https%3A%2F%2Fwww.prowrestling.com%2Fwp-content%2Fuploads%2F2020%2F12%2FKenny-Omega-Impact-Wrestling.jpeg&title=IMPACT%2BWrestling%2BResults%2B%252812%252F8%2529%253A%2BKenny%2BOmega%2BSpeaks%252C%2BKnockouts%2BTag%2BTournament%2BContinues%2521&tags=Featured"

    case vuukleEmotes = "https://cdn.vuukle.com/widgets/emotes.html?apiKey=c7368a34-dac3-4f39-9b7c-b8ac2a2da575&darkMode=false&host=smalltester.000webhostapp.com&articleId=381&img=https://smalltester.000webhostapp.com/wp-content/uploads/2017/10/wallhaven-303371-825x510.jpg&title=New&post&22&url=https://smalltester.000webhostapp.com/2017/12/new-post-22&emotesEnabled=true&firstImg=&secondImg=&thirdImg=&fourthImg=&fifthImg=&sixthImg=&totWideImg=false&articlesProtocol=http&hideArticles=false&disable=[]&iconsSize=70&first=HAPPY&second=INDIFFERENT&third=AMUSED&fourth=EXCITED&fifth=ANGRY&sixth=SAD&customText=%7B%7D"

    case vuuklePowerBar = "https://cdntest.vuukle.com/widgets/powerbar.html?amp=false&apiKey=664e0b85-5b2c-4881-ba64-3aa9f992d01c&host=relaxed-beaver-76304e.netlify.com&articleId=Index&img=https%3A%2F%2Fwww.gettyimages.ie%2Fgi-resources%2Fimages%2FHomepage%2FHero%2FUK%2FCMS_Creative_164657191_Kingfisher.jpg&title=Index&url=https%3A%2F%2Frelaxed-beaver-76304e.netlify.app%2F&tags=123&author=123&lang=en&gr=false&darkMode=false&defaultEmote=1&items=&standalone=0&mode=horizontal"

    // Social Login URLs
    case vuukleSocialLogin = "https://login.vuukle.com/auth"
    case vuukleSocialLoginSuccess = "https://login.vuukle.com/consent"

    // Settings Url
    case vuukleSettings = "https://news.vuukle.com/settings/edit-profile"

    // Social Share
    case vuukleFBShare = "https://www.facebook.com/share"
    case vuukleTwitterShare = "https://twitter.com/share"
    case vuukleWhatsappShare = "https://api.whatsapp.com/"
    case vuukleWebWhatsappShare = "https://web.whatsapp.com/send"
    case vuukleTelegramShare = "https://telegram.me/share"
    case vuukleLinkedinShare = "https://www.linkedin.com/shareArticle"
    case vuukleRedditShare = "https://www.reddit.com"
    case vuuklePinterestShare = "https://pinterest.com"
    case vuukleFlipboardShare  = "https://share.flipboard.com"
    case vuukleTumblrShare  = "https://tumblr.com/"
    case vuukleMailShare = "mailto:?subject"
    case vuukleMailToShare = "mailto:to?subject"
    case vuukleFBMessengerShare = "fb-messenger://share"

    // Vuukle News
    case vuukleNewsBaseURL = "https://news.vuukle.com/"

    // Listener Handling
    case external = "external"
    case source = "source"
    case talkOfTown = "talk_of_town"
    case emoteRecommendations = "emote_recommendations"

    // Vuukle Privacy
    case vuuklePrivacy = "https://docs.vuukle.com/privacy-and-policy/"
    // Vuukle notification base URL
    case vuukleNotificationBase = "https://api.vuukle.com"

    // Vuukle Base URL
    case vuukleBase = "https://vuukle.com/"
    case vuukleIframeBase = "https://cdn.vuukle.com"

    // MARK: - New

    case logoutClickedMessage = "logout-clicked"
    case signInButtonClickedMessage = "signin-clicked"

}
