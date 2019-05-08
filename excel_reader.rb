# coding: utf-8
# 単なるラッパーです。書き方を忘れてしまうので。
# エラーはなんかとりあえずfalseを返すです。
class ExcelReader
  # まあ、これは必須です
  require 'spreadsheet'

  # インスタンスはいるか？当然に
  # 2次元配列として扱おう
  def initialize(file_name, sheet_name, s_row, s_column) # シートぐらいは選べるようにします。多分ヘッダ部分を飛ばせるようにしたほうがいいですね
    # 戻り値です
    ret_value = [true, ""]
    # この配列を以後使用します
    @data_array = []
    begin
      Spreadsheet.open file_name do |book|
        sheet = book.worksheet(sheet_name) # すげーな。数字ならindexでstringなら名前ってどーよ。 
        start_row = s_row # 何行飛ばすか書いてある
        start_column = s_column
        # なんとdimensionsというvalueがありました
        dim = sheet.dimensions # [開始行, 終了行の次の行, 開始カラム, 終了カラムの次のカラム]
        end_row = dim[1] - 1
        end_column = dim[3] -1
        #p start_row, end_row
        #p start_column, end_column
        for i in start_row..end_row # 行ね
          @data_array[i - start_row] = []
          for j in start_column..end_column # 列ね
            @data_array[i - start_row][j - start_column] = sheet[i, j] # 開始位置を補正しないといけないです
          end
        end
      end
      # 戻り値はそのままで
    rescue => err
      # エラーはね、でますよ。やっぱり
      ret_value = [false, err]
    ensure
      # 戻り値は絶対に返します
      return ret_value
    end
  end

  # とりあえずシートのデータをまるごと持ってきます
  # keyとvalueだけのシートならめっちゃ取り扱いやすかったりするです
  def get_value
    return @data_array
  end

# めんどいから今は作りません  
=begin
  def get_row(row_no)

  end

  def get_column(col_no)

  end

  def get_cell(row_no, clo_no)

  end

  # 矩形で取得することってあるかな？
  # ないな。多分

  def put_row(row_values)

  end

  def put_column(col_values)

  end

  # 多分このパターンはない
  def put_cell(row_no, clo_no)

  end

  def patch_row(row_no, row_values)

  end

  def patch_column(col_no, col_values)

  end

  def patch_cell(row_no, clo_no, val)

  end

  # このメソッドで変更を反映させよう
  def update


  end
=end

end
