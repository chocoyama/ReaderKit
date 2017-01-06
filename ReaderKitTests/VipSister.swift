//
//  VipSister.swift
//  ReaderKit
//
//  Created by takyokoy on 2016/11/01.
//  Copyright © 2016年 chocoyama. All rights reserved.
//

import Foundation

@testable import ReaderKit

extension ReaderKitTestsResources {
    static var vipSister: Document {
        let documentTitle = "妹はVipper"
        let documentLink = URL(string: "http://vipsister23.com/index.rdf")!
        let items: [DocumentItem] = [
            .init(
                documentTitle: documentTitle,
                documentLink: documentLink,
                title: "【画像あり】ノゾキアナとかいクソビッチ一般漫画ｗｗｗｗｗｗ",
                link: URL(string: "http://vipsister23.com/archives/8631629.html")!,
                desc: "10: 風吹けば名無し＠＼(^o^)／ 2016/10/31(月) 09:29:28.07 ID:ViGl/+VX0",
                date: "2016-11-01T11:05:05Z".toDate(format: "yyyy-MM-dd'T'HH:mm:ssZ")!,
                read: false
            ),
            .init(
                documentTitle: documentTitle,
                documentLink: documentLink,
                title: "【画像あり】ツイッターで『エロ写メ』とかで検索してるお前らｗｗｗｗｗｗｗｗｗｗｗｗｗ",
                link: URL(string: "http://vipsister23.com/archives/8631606.html")!,
                desc: "1: 名無しさん＠おーぷん 2015/07/01(水)12:11:30 ID:XON 最高ンゴねぇ・・・",
                date: "2016-11-01T11:03:10Z".toDate(format: "yyyy-MM-dd'T'HH:mm:ssZ")!,
                read: false
            ),
            .init(
                documentTitle: documentTitle,
                documentLink: documentLink,
                title: "【悲報】性の悦びおじさん、面白くない奴らに見つかり終了",
                link: URL(string: "http://vipsister23.com/archives/8631473.html")!,
                desc: "1: 風吹けば名無し＠＼(^o^)／ 2016/11/01(火) 12:04:44.08 ID:zbY7DjNs0.net 馬鹿共に見つかり記念撮影なんかしだす始末 遠巻きに観察するのが面白かったというのにね コミュニティの一生コピペとおんなじ末路を辿ってる",
                date: "2016-11-01T10:23:48Z".toDate(format: "yyyy-MM-dd'T'HH:mm:ssZ")!,
                read: false
            ),
            .init(
                documentTitle: documentTitle,
                documentLink: documentLink,
                title: "【エロ注意】今月のToLOVEるもうエッロエロｗｗｗｗｗｗｗｗｗ",
                link: URL(string: "http://vipsister23.com/archives/8631506.html")!,
                desc: "1: 以下、＼(^o^)／でVIPがお送りします 2016/11/01(火) 15:34:03.393 ID:q/wo4W6z0.net やったな！ 3: 以下、＼(^o^)／でVIPがお送りします 2016/11/01(火) 15:34:39.395 ID:EbzGUmY50.net 【エロ画像注意】http://livedoor.blogimg.jp/vipsister23/imgs/0/e/0e8549e8...",
                date: "2016-11-01T11:00:56Z".toDate(format: "yyyy-MM-dd'T'HH:mm:ssZ")!,
                read: false
            ),
            .init(
                documentTitle: documentTitle,
                documentLink: documentLink,
                title: "【GIF】なんJ民の87%が笑うgifｗｗｗｗｗｗｗｗｗ",
                link: URL(string: "http://vipsister23.com/archives/8631503.html")!,
                desc: "30: 風吹けば名無し＠＼(^o^)／ 2016/10/30(日) 08:33:35.82 ID:LINfoUzg0.net 70: 風吹けば名無し＠＼(^o^)／ 2016/10/30(日) 08:46:28.34 ID:RN4EUXr/d.net &gt;&gt;30 草",
                date: "2016-11-01T10:10:47Z".toDate(format: "yyyy-MM-dd'T'HH:mm:ssZ")!,
                read: false
            )
        ]
        let vipSister = Document.init(
            title: documentTitle,
            link: documentLink,
            items: items
        )
        return vipSister
    }
}
