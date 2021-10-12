＃norn
保存データの形式

時刻表データ Timetable 
name: 駅の名前
destination: 方面
dowcode: 曜日コード 0:平日 1:土曜 2:日曜・祝日
timestamp: 更新日時
timetable: 時刻表 [[時刻,分,分,...],[時刻,分,分,...],...]の形で一つ目の要素がその配列が何時のものかを表す

組み合わせデータ Mytable
departure: 出発地点
arrivel: 到着地点
middle: 中間地点 配列で途中の駅を保存
needtime: 駅と駅の間の所要時間 middleと対応した配列の形で保存

