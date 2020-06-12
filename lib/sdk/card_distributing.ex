defmodule WeChat.SDK.CardDistributing do
  @moduledoc """
  微信卡券 - 投放卡券

  [API Docs Link](https://developers.weixin.qq.com/doc/offiaccount/Cards_and_Offer/Distributing_Coupons_Vouchers_and_Cards.html){:target="_blank"}
  """
  import Jason.Helpers
  alias WeChat.{SDK, SDK.Card}

  @doc_link "#{SDK.doc_link_prefix()}/offiaccount/Cards_and_Offer/Distributing_Coupons_Vouchers_and_Cards.html"

  @doc """
  创建二维码接口

  开发者可调用该接口生成一张卡券二维码供用户扫码后添加卡券到卡包。

  自定义Code码的卡券调用接口时，POST数据中需指定code，非自定义code不需指定，指定openid同理。指定后的二维码只能被用户扫描领取一次。

  获取二维码ticket后，开发者可用[换取二维码图片详情](#{SDK.doc_link_prefix()}/offiaccount/Account_Management/Generating_a_Parametric_QR_Code.html)。

  ## API Docs
    [link](#{@doc_link}#0){:target="_blank"}
  """
  @spec create_qrcode(SDK.client(), body :: map) :: SDK.response()
  def create_qrcode(client, body) do
    client.request(:post, url: "/card/qrcode/create", body: body)
  end

  @doc """
  创建货架接口

  开发者需调用该接口创建货架链接，用于卡券投放。创建货架时需填写投放路径的场景字段。

  ## API Docs
    [link](#{@doc_link}#3){:target="_blank"}
  """
  @spec create_landing_page(SDK.client(), body :: map) :: SDK.response()
  def create_landing_page(client, body) do
    client.request(:post, url: "/card/landingpage/create", body: body)
  end

  @doc """
  群发卡券 - 导入自定义code(仅对自定义code商户)

  ## API Docs
    [link](#{@doc_link}#5){:target="_blank"}
  """
  @spec import_code(SDK.client(), Card.card_id(), [Card.card_code()]) :: SDK.response()
  def import_code(client, card_id, code_list) do
    client.request(:post,
      url: "/card/code/deposit",
      body: json_map(card_id: card_id, code: code_list)
    )
  end

  @doc """
  群发卡券 - 查询导入code数目接口

  ## API Docs
    [link](#{@doc_link}#5){:target="_blank"}
  """
  @spec get_code_count(SDK.client(), Card.card_id()) :: SDK.response()
  def get_code_count(client, card_id) do
    client.request(:post, url: "/card/code/getdepositcount", body: json_map(card_id: card_id))
  end

  @doc """
  群发卡券 - 核查code接口

  ## API Docs
    [link](#{@doc_link}#5){:target="_blank"}
  """
  @spec check_code(SDK.client(), Card.card_id(), [Card.card_code()]) :: SDK.response()
  def check_code(client, card_id, code_list) do
    client.request(:post,
      url: "/card/code/checkcode",
      body: json_map(card_id: card_id, code: code_list)
    )
  end

  @doc """
  图文消息群发卡券

  支持开发者调用该接口获取卡券嵌入图文消息的标准格式代码，将返回代码填入 [新增临时素材](#{SDK.doc_link_prefix()}/offiaccount/Asset_Management/New_temporary_materials) 中content字段，即可获取嵌入卡券的图文消息素材。

  特别注意：目前该接口仅支持填入非自定义code的卡券,自定义code的卡券需先进行code导入后调用。

  ## API Docs
    [link](#{@doc_link}#6){:target="_blank"}
  """
  @spec get_mp_news_html(SDK.client(), Card.card_id()) :: SDK.response()
  def get_mp_news_html(client, card_id) do
    client.request(:post, url: "/card/mpnews/gethtml", body: json_map(card_id: card_id))
  end

  @doc """
  设置测试白名单

  ## API Docs
    [link](#{@doc_link}#12){:target="_blank"}
  """
  @spec set_test_whitelist(SDK.client(), [
          {:openid, [SDK.openid()]} | {:username, [SDK.username()]}
        ]) :: SDK.response()
  def set_test_whitelist(client, openid: openid_list) do
    client.request(:post, url: "/card/testwhitelist/set", body: json_map(openid: openid_list))
  end

  @spec set_test_whitelist(SDK.client(), [SDK.username()]) :: SDK.response()
  def set_test_whitelist(client, username: username_list) do
    client.request(:post, url: "/card/testwhitelist/set", body: json_map(username: username_list))
  end

  @doc """
  设置测试白名单

  ## API Docs
    [link](#{@doc_link}#12){:target="_blank"}
  """
  @spec set_test_whitelist(SDK.client(), [SDK.openid()], [SDK.username()]) :: SDK.response()
  def set_test_whitelist(client, openid_list, username_list) do
    client.request(:post,
      url: "/card/testwhitelist/set",
      body: json_map(openid: openid_list, username: username_list)
    )
  end
end
