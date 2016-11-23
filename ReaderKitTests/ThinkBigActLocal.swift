//
//  ThinkBigActLocal.swift
//  ReaderKit
//
//  Created by takyokoy on 2016/11/01.
//  Copyright © 2016年 chocoyama. All rights reserved.
//

import Foundation
@testable import ReaderKit

extension ReaderKitTestsResources {
    static var thinkBigActLocal: Document {
        let documentTitle = "Think Big Act Local"
        let documentLink = URL(string: "http://himaratsu.hatenablog.com/feed")!
        let items: [Document.Item] = [
//            .init(
//                documentTitle: documentTitle,
//                documentLink: documentLink,
//                title: "iOSDC 2016に参加してきたよ #iosdc",
//                link: URL(string: "http://himaratsu.hatenablog.com/entry/iosdc2016")!,
//                desc: "iOSDC 2016という、日本最大級のiOSのカンファレンスに参加してきました。 iosdc.jp iOSDCはiOS・その周辺技術に関するカンファレンスで、公式サイトには「iOSエンジニアが聞いて面白ければ何でもOK」と説明されています。 トークは数多くの応募の中から運営スタッフにより採択されます。当日は技術的なテーマはもちろん、「海外のカンファレンスで登壇する」や「ハッピーな開発チームを築く」など、幅広い内容のトークが行われました。 以下、参加した記録として気になったセッションや会場の様子などを振り返ってみたいと思います。 振り返り 会場 会場は練馬のCoconeriホールという場所でし…",
//                date: "2016-08-23T02:16:21+09:00".toDate(format: "yyyy-MM-dd'T'HH:mm:ssZ")!,
//                read: false
//            ),
//            .init(
//                documentTitle: documentTitle,
//                documentLink: documentLink,
//                title: "potatotipsでUICollectionViewの並び替えのAPIについて発表してきたよ",
//                link: URL(string: "http://himaratsu.hatenablog.com/entry/collectionviewreorder")!,
//                desc: "FiNCさんで開催された、potatotips #31 で発表してきました。 potatotips.connpass.com 発表した内容 タイトルの通り、UICollectionViewのCellをインタラクティブに並び替えるAPIの紹介です。 デモ こんな感じで、 CollectionViewの（インタラクティブな）並び替え サイズの異なるCell間の並び替え pagingEnabled=trueの場合の並び替え などができます。iPhoneのホーム画面のような挙動ですね。 経緯 WWDC2016で参加したセッションの1つに「What&#39;s New in UICollectionView i…",
//                date: "2016-08-17T23:38:40+09:00".toDate(format: "yyyy-MM-dd'T'HH:mm:ssZ")!,
//                read: false
//            ),
            .init(
                documentTitle: documentTitle,
                documentLink: documentLink,
                title: "【書評】基本が身につくAndroidアプリ開発入門書",
                link: URL(string: "http://himaratsu.hatenablog.com/entry/book/android")!,
                desc: "著者の森さんより、『基本からしっかり身につく Androidアプリ開発入門』を献本いただきました。 タイトルの通りAndroidアプリ開発をこれからはじめたい人向けの本で、Amazonでもベストセラーになっているようです。 この本は「ヤフー黒帯シリーズ」として出版されています。黒帯とはヤフーの中で特に優秀な人材に付与される称号で、著者の森さんはAndroid技術黒帯に認定されています。 iOSアプリ入門の黒帯本が少し前に出ていて、自分も読んだのですが、今回のAndroid黒帯本も構成などはそれに似ていると思います。 本気ではじめるiPhoneアプリ作り Xcode 7.x＋Swift 2.x対…",
                date: "2016-08-09T20:22:26+09:00".toDate(format: "yyyy-MM-dd'T'HH:mm:ssZ")!,
                read: false
            ),
            .init(
                documentTitle: documentTitle,
                documentLink: documentLink,
                title: "「売れるもマーケ 当たるもマーケ マーケティング22の法則」を読んだ",
                link: URL(string: "http://himaratsu.hatenablog.com/entry/marketing22")!,
                desc: "売れるもマーケ 当たるもマーケ―マーケティング22の法則作者: アルライズ,ジャックトラウト,Al Ries,Jack Trout,新井喜美夫出版社/メーカー: 東急エージェンシー出版部発売日: 1994/01メディア: 単行本購入: 17人 クリック: 250回この商品を含むブログ (61件) を見る この本は過去に実際にあったマーケティングの話をベースに、「こうしなければいけない」「こうしちゃうと死ぬ」みたいな法則をまとめている本です。一部ではマーケティングの教科書とも呼ばれているみたいです 。 自分は以前から「似たような機能をもったプロダクトは沢山あるのに、なぜこのプロダクトだけが流行る…",
                date: "2016-06-05T20:07:27+09:00".toDate(format: "yyyy-MM-dd'T'HH:mm:ssZ")!,
                read: false
            ),
            .init(
                documentTitle: documentTitle,
                documentLink: documentLink,
                title: "ユーザーの声に耳を傾けてアプリを改善するサービス「Meyasubaco」をつくりました",
                link: URL(string: "http://himaratsu.hatenablog.com/entry/meyasubaco")!,
                desc: "meyasuba.co 自分がアプリ開発を行っているときに考えてるのが「この機能とかUIはアプリのユーザーに伝わっているのかな？」ということです。 どれだけ良い機能でもユーザーに使われなければ意味がない。だからユーザーの気持ちになって考えることは常に意識してるのですが、これがとても難しいです。自分はIT業界にいて色んなアプリを触ってるし、機能について考えまくってるのでユーザーと同じ目線をなかなか持ちにくいんですね。 なので、これまではアプリに仕込んだイベントログからユーザーの行動を推測していました。自分はGoogle Analyticsを使ってるのですが、それを見て 「あーこのボタンは気付かれ…",
                date: "2016-06-02T20:12:55+09:00".toDate(format: "yyyy-MM-dd'T'HH:mm:ssZ")!,
                read: false
            )
        ]
        let thinkBigActLocal = Document.init(
            title: documentTitle,
            link: documentLink,
            items: items
        )
        return thinkBigActLocal
    }
}
