# coding: utf-8
require "./excel_reader.rb"
require 'selenium-webdriver'
require 'chromedriver-helper'

# データ読んじゃう
file_name = "#{Dir.pwd}/data.xls"
identification = ExcelReader.new(file_name, "ID", 0, 0).get_value
#p identification
# hashにしちゃいますよ
identification = Hash[*identification.flatten]
p identification
profile = ExcelReader.new(file_name, "DATA", 0, 0).get_value
#p profile
profile = Hash[*profile.flatten]
p profile

# webdriverの条件
options = Selenium::WebDriver::Chrome::Options.new
options.add_argument('--headless')
driver = Selenium::WebDriver.for :chrome, options: options
wait = Selenium::WebDriver::Wait.new(:timeout => 30)

# 準備
# 自分で大きさ決めてみる
page_width = 1000
page_height = 1500
driver.manage.window.resize_to(page_width, page_height)
# ログイン画面のURL
LOGIN_URL = 'https://event.shoeisha.jp/order/apply/235/'
driver.navigate.to LOGIN_URL
# 確認確認
driver.save_screenshot './se_event_1.png'

# ログインじゃ
wait.until {driver.find_element(:name, 'login').displayed?} # ログインボタンが表示されるまで待ちます
mail_address = driver.find_element(:name, 'email')
password = driver.find_element(:name, 'login_password')
mail_address.send_keys(identification['ID'])
password.send_keys(identification['PASSWORD'])
# また確認
driver.save_screenshot './se_event_2.png'
# サブミット
driver.find_element(:name, 'login').click
# 縦に長かった
page_height = 2500
driver.manage.window.resize_to(page_width, page_height)
# しつこいけど確認
driver.save_screenshot './se_event_3.png'

# 入力するぞ
# 次へのボタンがstep1って名前でした。なんで？
wait.until {driver.find_element(:name, 'step1').displayed?}
# 次々入れていきます
driver.find_element(:name, 'family_name').send_keys(profile['姓'])
driver.find_element(:name, 'given_name').send_keys(profile['名'])
driver.find_element(:name, 'family_name_kana').send_keys(profile['せい'])
driver.find_element(:name, 'given_name_kana').send_keys(profile['めい'])
driver.find_element(:name, 'companyname').send_keys(profile['会社名'])
driver.find_element(:name, 'company_dept').send_keys(profile['部署名'])
# やばい。ここからselectだ
Selenium::WebDriver::Support::Select.new(driver.find_element(:name, 'company_title')).select_by(:text, profile['役職'])
Selenium::WebDriver::Support::Select.new(driver.find_element(:name, 'company_division')).select_by(:text, profile['所属部門'])
Selenium::WebDriver::Support::Select.new(driver.find_element(:name, 'company_job')).select_by(:text, profile['職種'])
Selenium::WebDriver::Support::Select.new(driver.find_element(:name, 'company_industries')).select_by(:text, profile['業種'])
Selenium::WebDriver::Support::Select.new(driver.find_element(:name, 'company_employee_number')).select_by(:text, profile['従業員数'])
# ふー、終了した
driver.find_element(:name, 'postcode_1').send_keys(profile['郵便番号1'])
driver.find_element(:name, 'postcode_2').send_keys(profile['郵便番号2'])
# またかよ
Selenium::WebDriver::Support::Select.new(driver.find_element(:name, 'city')).select_by(:text, profile['都道府県'])
driver.find_element(:name, 'address').send_keys(profile['市区町村'])
driver.find_element(:name, 'block').send_keys(profile['番地'])
driver.find_element(:name, 'building').send_keys(profile['ビル名'])
# 電話番号めんどい
driver.find_element(:name, 'tel_1').send_keys(profile['電話番号1'])
driver.find_element(:name, 'tel_2').send_keys(profile['電話番号2'])
driver.find_element(:name, 'tel_3').send_keys(profile['電話番号3'])
driver.find_element(:name, 'fax_1').send_keys(profile['FAX番号1'])
driver.find_element(:name, 'fax_2').send_keys(profile['FAX番号2'])
driver.find_element(:name, 'fax_3').send_keys(profile['FAX番号3'])

# チェックは外します
if driver.find_element(:id, 'se-profile-action').selected? # チェックされてたらuncheckするよ？
  driver.find_element(:id, 'se-profile-action').click
end
# ここでも確認
driver.save_screenshot './se_event_4.png'




