defmodule WeChat.SDK.Card do
  @moduledoc """
  微信卡券

  [API Docs Link](https://developers.weixin.qq.com/doc/offiaccount/Cards_and_Offer/WeChat_Coupon_Interface.html){:target="_blank"}
  """
  import Jason.Helpers
  alias WeChat.SDK

  @doc_link "#{SDK.doc_link_prefix()}/offiaccount/Cards_and_Offer"

  @type card_id :: String.t()
  @typedoc """
  卡券类型
    * `"GROUPON"`         - 团购券
    * `"DISCOUNT"`        - 折扣券
    * `"GIFT"`            - 礼品券
    * `"CASH"`            - 代金券
    * `"GENERAL_COUPON"`  - 通用券
    * `"MEMBER_CARD"`     - 会员卡
    * `"SCENIC_TICKET"`   - 景点门票
    * `"MOVIE_TICKET"`    - 电影票
    * `"BOARDING_PASS"`   - 飞机票
    * `"MEETING_TICKET"`  - 会议门票
    * `"BUS_TICKET"`      - 汽车票
  """
  @type card_type :: String.t()
  @type card_code :: String.t()
  @typedoc """
  支持开发者拉出指定状态的卡券列表
    * `"CARD_STATUS_NOT_VERIFY"`  - 待审核
    * `"CARD_STATUS_VERIFY_FAIL"` - 审核失败
    * `"CARD_STATUS_VERIFY_OK"`   - 通过审核
    * `"CARD_STATUS_DELETE"`      - 卡券被商户删除
    * `"CARD_STATUS_DISPATCH"`    - 在公众平台投放过的卡券
  """
  @type card_status :: String.t()
  @typedoc """
  | type                      | description      | 适用核销方式                                                 |
  | ------------------------- | ---------------- | ------------------------------------------------------------ |
  | `"CODE_TYPE_QRCODE"`      | 二维码显示code   | 适用于扫码/输码核销                                          |
  | `"CODE_TYPE_BARCODE"`     | 一维码显示code   | 适用于扫码/输码核销                                          |
  | `"CODE_TYPE_ONLY_QRCODE"` | 二维码不显示code | 仅适用于扫码核销                                             |
  | `"CODE_TYPE_TEXT"`        | 仅code类型       | 仅适用于输码核销                                             |
  | `"CODE_TYPE_NONE"`        | 无code类型       | 仅适用于线上核销，开发者须自定义跳转链接跳转至H5页面，允许用户核销掉卡券，自定义cell的名称可以命名为“立即使用” |
  """
  @type code_type :: String.t()
  @type date :: Date.t() | String.t()
  @typedoc """
  卡券来源
    * `0` - 为公众平台创建的卡券数据
    * `1` - 是API创建的卡券数据
  """
  @type cond_source :: 0 | 1

  @doc """
  创建卡券

  ## API Docs
    [link](#{@doc_link}/Create_a_Coupon_Voucher_or_Card.html#8){:target="_blank"}
  """
  @spec create(SDK.client(), body :: map) :: SDK.response()
  def create(client, body) do
    client.request(:post, url: "/card/create", body: body)
  end

  @doc """
  查询Code

  ## API Docs
    [link](#{@doc_link}/Redeeming_a_coupon_voucher_or_card.html#1){:target="_blank"}
  """
  @spec check_card_code(SDK.client(), card_id, card_code, check_consume :: boolean) ::
          SDK.response()
  def check_card_code(client, card_id, card_code, check_consume \\ true) do
    client.request(
      :post,
      url: "/card/code/get",
      body: json_map(card_id: card_id, code: card_code, check_consume: check_consume)
    )
  end
end
