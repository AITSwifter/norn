＃norn
保存データの形式

時刻表データ Station
name: 駅の名前
destination: 方面
timestamp: 更新日時
ordinarytable: 平日の時刻表
saturdaytable:土曜の時刻表
sundaytable:日曜・祝日の時刻表
各時刻表データの形式
[分,分,...],[分,分,...],...]の形式で入力されたint配列をバイナリデータに変換したもの。
5時から24時までの計20の要素を持っている。その時間にバスがない場合は配列の中身はなし

組み合わせデータ Preset
departure: 出発地点
arrivel: 到着地点
middle: 中間地点 配列で途中の駅を保存
needtime: 駅と駅の間の所要時間 middleと対応した配列の形で保存

