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
5時から24時までの計20の要素を持っている。その時間にバスがない場合は配列の中身はなし。昇順でソート済み
timestamp: 更新や保存された時の日時 ソート用

組み合わせデータ Preset
name: プリセットの名前
start: 開始地点の駅名
sdirect: 開始地点の方面
middname: 中間地点の駅名 配列で途中の駅の名前を保存、到着地点の駅を含む
midddir: 中間地点の方面　配列で途中の駅の方面を保存、到着地点の駅を含む
needtime: 駅と駅の間の所要時間 middleと対応した配列の形で保存
timestamp: 更新や保存された時の日時 ソート用
