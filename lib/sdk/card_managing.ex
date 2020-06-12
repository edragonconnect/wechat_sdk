defmodule WeChat.SDK.CardManaging do
  @moduledoc """
  微信卡券 - 管理卡券

  [API Docs Link](https://developers.weixin.qq.com/doc/offiaccount/Cards_and_Offer/Managing_Coupons_Vouchers_and_Cards.html){:target="_blank"}
  """
  import Jason.Helpers
  alias WeChat.{SDK, SDK.Card}

  @doc_link "#{SDK.doc_link_prefix()}/offiaccount/Cards_and_Offer/Managing_Coupons_Vouchers_and_Cards.html"

  @doc """
  获取用户已领取卡券

  ## API Docs
    [link](#{@doc_link}#1){:target="_blank"}
  """
  @spec get_user_card_list(SDK.client(), SDK.openid()) :: SDK.response()
  def get_user_card_list(client, openid) do
    client.request(
      :post,
      url: "/card/user/getcardlist",
      body: json_map(openid: openid)
    )
  end

  def get_user_card_list(client, openid, card_id) do
    client.request(
      :post,
      url: "/card/user/getcardlist",
      body: json_map(openid: openid, card_id: card_id)
    )
  end

  @doc """
  查看卡券详情

  ## API Docs
    [link](#{@doc_link}#2){:target="_blank"}
  """
  @spec get_card_info(SDK.client(), Card.card_id()) :: SDK.response()
  def get_card_info(client, card_id) do
    client.request(
      :post,
      url: "/card/get",
      body: json_map(card_id: card_id)
    )
  end

  @doc """
  批量查询卡券列表

  ## API Docs
    [link](#{@doc_link}#3){:target="_blank"}
  """
  @spec batch_get_cards(SDK.client(), count :: integer, offset :: integer) :: SDK.response()
  def batch_get_cards(client, count, offset) when count <= 50 do
    client.request(
      :post,
      url: "/card/batchget",
      body: json_map(offset: offset, count: count)
    )
  end

  @doc """
  批量查询卡券列表 - 只获取指定状态

  ## API Docs
    [link](#{@doc_link}#3){:target="_blank"}
  """
  @spec batch_get_cards(SDK.client(), [Card.card_status()], count :: integer, offset :: integer) ::
          SDK.response()
  def batch_get_cards(client, status_list, count, offset) when count <= 50 do
    client.request(
      :post,
      url: "/card/batchget",
      body: json_map(offset: offset, count: count, status_list: status_list)
    )
  end

  @doc """
  更改卡券信息

  ## API Docs
    [link](#{@doc_link}#4){:target="_blank"}
  """
  @spec update_card_info(SDK.client(), Card.card_id(), Card.card_type(), card_info :: map) ::
          SDK.response()
  def update_card_info(client, card_id, card_type, card_info) do
    client.request(
      :post,
      url: "/card/update",
      body: %{
        "card_id" => card_id,
        card_type => card_info
      }
    )
  end

  @doc """
  修改库存

  ## API Docs
    [link](#{@doc_link}#5){:target="_blank"}
  """
  @spec modify_card_stock(SDK.client(), Card.card_id(), change_count :: integer) :: SDK.response()
  def modify_card_stock(client, card_id, change_count) do
    body =
      if change_count > 0 do
        json_map(card_id: card_id, increase_stock_value: change_count)
      else
        json_map(card_id: card_id, reduce_stock_value: -change_count)
      end
      |> Jason.encode!()

    client.request(:post, url: "/card/modifystock", body: body)
  end

  @doc """
  更改Code

  ## API Docs
    [link](#{@doc_link}#6){:target="_blank"}
  """
  @spec update_card_code(SDK.client(), Card.card_id(), Card.card_code(), Card.card_code()) ::
          SDK.response()
  def update_card_code(client, card_id, old_code, new_code) do
    client.request(
      :post,
      url: "/card/code/update",
      body: json_map(card_id: card_id, code: old_code, new_code: new_code)
    )
  end

  @doc """
  删除卡券

  ## API Docs
    [link](#{@doc_link}#7){:target="_blank"}
  """
  @spec check_card_code(SDK.client(), Card.card_id()) :: SDK.response()
  def check_card_code(client, card_id) do
    client.request(
      :post,
      url: "/card/delete",
      body: json_map(card_id: card_id)
    )
  end

  @doc """
  设置卡券失效接口-非自定义code卡券的请求

  ## API Docs
    [link](#{@doc_link}#8){:target="_blank"}
  """
  @spec unavailable_card_code(SDK.client(), Card.card_code(), reason :: String.t()) ::
          SDK.response()
  def unavailable_card_code(client, code, reason) do
    client.request(
      :post,
      url: "/card/code/unavailable",
      body: json_map(code: code, reason: reason)
    )
  end

  @doc """
  设置卡券失效接口-自定义code卡券的请求

  ## API Docs
    [link](#{@doc_link}#8){:target="_blank"}
  """
  @spec unavailable_card_code(
          SDK.client(),
          Card.card_id(),
          Card.card_code(),
          reason :: String.t()
        ) ::
          SDK.response()
  def unavailable_card_code(client, card_id, code, reason) do
    client.request(
      :post,
      url: "/card/code/unavailable",
      body: json_map(card_id: card_id, code: code, reason: reason)
    )
  end

  @doc """
  拉取卡券概况数据

  ## API Docs
    [link](#{@doc_link}#10){:target="_blank"}
  """
  @spec get_card_bizuin_info(
          SDK.client(),
          begin_date :: Card.date(),
          end_date :: Card.date(),
          Card.cond_source()
        ) ::
          SDK.response()
  def get_card_bizuin_info(client, begin_date, end_date, cond_source \\ 1)
      when cond_source in 0..1 do
    client.request(
      :post,
      url: "/datacube/getcardbizuininfo",
      body: json_map(begin_date: begin_date, end_date: end_date, cond_source: cond_source)
    )
  end

  @doc """
  获取免费券数据

  ## API Docs
    [link](#{@doc_link}#11){:target="_blank"}
  """
  @spec get_card_analysis(
          SDK.client(),
          begin_date :: Card.date(),
          end_date :: Card.date(),
          Card.cond_source()
        ) ::
          SDK.response()
  def get_card_analysis(client, begin_date, end_date, cond_source) when cond_source in 0..1 do
    client.request(
      :post,
      url: "/datacube/getcardcardinfo",
      body: json_map(begin_date: begin_date, end_date: end_date, cond_source: cond_source)
    )
  end

  @doc """
  获取免费券数据 - 只获取指定卡券

  ## API Docs
    [link](#{@doc_link}#11){:target="_blank"}
  """
  @spec get_card_analysis(
          SDK.client(),
          Card.card_id(),
          begin_date :: Card.date(),
          end_date :: Card.date(),
          Card.cond_source()
        ) :: SDK.response()
  def get_card_analysis(client, card_id, begin_date, end_date, cond_source)
      when cond_source in 0..1 do
    client.request(
      :post,
      url: "/datacube/getcardcardinfo",
      body:
        json_map(
          begin_date: begin_date,
          end_date: end_date,
          cond_source: cond_source,
          card_id: card_id
        )
    )
  end
end
