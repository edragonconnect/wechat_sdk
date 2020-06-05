defmodule WeChat.SDK.Material do
  @moduledoc "素材管理"
  import Jason.Helpers
  alias WeChat.{SDK, UploadMedia, UploadMediaContent}

  @typedoc """
  素材的类型

  图片（image）、视频（video）、语音 （voice）、图文（news）

    * String.t :: ["image", "video", "voice", "news"]
    * atom :: [:image, :video, :voice, :news]
  """
  @type material_type :: String.t() | atom
  @typedoc """
  素材的数量，取值在1到20之间

  material_count in 1..20
  """
  @type material_count :: integer
  @type media_id :: String.t()
  @type article :: SDK.Article.t()

  @doc """
  新增临时素材

  ## API Docs
    [link](https://developers.weixin.qq.com/doc/offiaccount/Asset_Management/New_temporary_materials.html){:target="_blank"}
  """
  @spec upload_media(SDK.client(), material_type, file_path :: Path.t()) :: SDK.response()
  def upload_media(client, type, file_path) do
    media = %UploadMedia{type: type, file_path: file_path}
    body = %{media: media}

    client.request(
      :post,
      url: "/cgi-bin/media/upload",
      body: {:form, body}
    )
  end

  @spec upload_media(SDK.client(), material_type, file_name :: String.t(), file_content :: binary) ::
          SDK.response()
  def upload_media(client, type, file_name, file_content) do
    media = %UploadMediaContent{type: type, file_name: file_name, file_content: file_content}
    body = %{media: media}

    client.request(
      :post,
      url: "/cgi-bin/media/upload",
      body: {:form, body}
    )
  end

  @doc """
  获取临时素材

  ## API Docs
    [link](https://developers.weixin.qq.com/doc/offiaccount/Asset_Management/Get_temporary_materials.html){:target="_blank"}
  """
  @spec get_media(SDK.client(), media_id) :: SDK.response()
  def get_media(client, media_id) do
    client.request(
      :get,
      url: "/cgi-bin/media/upload",
      query: [
        media_id: media_id
      ]
    )
  end

  @doc """
  新增永久图文素材

  ## API Docs
    [link](https://developers.weixin.qq.com/doc/offiaccount/Asset_Management/Adding_Permanent_Assets.html#新增永久图文素材){:target="_blank"}
  """
  @spec add_news(SDK.client(), articles :: [article]) :: SDK.response()
  def add_news(client, articles) do
    client.request(
      :post,
      url: "/cgi-bin/material/add_news",
      body: json_map(articles: articles)
    )
  end

  #  @doc """
  #  上传图文消息内的图片获取URL
  #
  #  ## API Docs
  #    [link](https://developers.weixin.qq.com/doc/offiaccount/Asset_Management/Adding_Permanent_Assets.html#上传图文消息内的图片获取URL){:target="_blank"}
  #  """
  #  @spec upload_image(SDK.client, file_path :: Path.t) :: SDK.response
  #  def upload_image(client, file_path) do
  #    media = %UploadMedia{file_path: file_path}
  #    body = %{media: media}
  #    client.request(
  #      :post,
  #      url: "/cgi-bin/media/uploadimg",
  #      body: {:form, body}
  #    )
  #  end
  #  @spec upload_image(SDK.client, file_name :: String.t, file_content :: binary) :: SDK.response
  #  def upload_image(client, type, file_name, file_content) do
  #    media = %UploadMediaContent{file_name: file_name, file_content: file_content}
  #    body = %{media: media}
  #    client.request(
  #      :post,
  #      url: "/cgi-bin/media/uploadimg",
  #      body: {:form, body}
  #    )
  #  end
  #
  #  @doc """
  #  新增其他类型永久素材
  #
  #  ## API Docs
  #    [link](https://developers.weixin.qq.com/doc/offiaccount/Asset_Management/Adding_Permanent_Assets.html#新增其他类型永久素材){:target="_blank"}
  #  """
  #  def add_material(client) do
  #    :todo
  #  end

  @doc """
  获取永久素材

  ## API Docs
    [link](https://developers.weixin.qq.com/doc/offiaccount/Asset_Management/Getting_Permanent_Assets.html){:target="_blank"}
  """
  @spec get_material(SDK.client(), media_id) :: SDK.response()
  def get_material(client, media_id) do
    client.request(
      :post,
      url: "/cgi-bin/material/get_material",
      body: json_map(media_id: media_id)
    )
  end

  @doc """
  删除永久素材

  ## API Docs
    [link](https://developers.weixin.qq.com/doc/offiaccount/Asset_Management/Deleting_Permanent_Assets.html){:target="_blank"}
  """
  @spec del_material(SDK.client(), media_id) :: SDK.response()
  def del_material(client, media_id) do
    client.request(
      :post,
      url: "/cgi-bin/material/del_material",
      body: json_map(media_id: media_id)
    )
  end

  @doc """
  修改永久图文素材

  ## API Docs
    [link](https://developers.weixin.qq.com/doc/offiaccount/Asset_Management/Editing_Permanent_Rich_Media_Assets.html){:target="_blank"}
  """
  @spec update_news(SDK.client(), media_id, article, index :: integer) :: SDK.response()
  def update_news(client, media_id, article, index \\ 0) do
    # 不支持编辑最后两个字段
    article =
      article
      |> Map.from_struct()
      |> Map.drop([:need_open_comment, :only_fans_can_comment])

    client.request(
      :post,
      url: "/cgi-bin/material/update_news",
      body:
        json_map(
          media_id: media_id,
          index: index,
          article: article
        )
    )
  end

  @doc """
  获取素材总数

  ## API Docs
    [link](https://developers.weixin.qq.com/doc/offiaccount/Asset_Management/Get_the_total_of_all_materials.html){:target="_blank"}
  """
  @spec get_material_count(SDK.client()) :: SDK.response()
  def get_material_count(client) do
    client.request(:get, url: "/cgi-bin/material/get_materialcount")
  end

  @doc """
  获取素材列表

  ## 参数说明:
    * type:   素材的类型，图片（image）、视频（video）、语音 （voice）、图文（news）
    * offset: 从全部素材的该偏移位置开始返回，0表示从第一个素材 返回
    * count:  返回素材的数量，取值在1到20之间

  ## API Docs
    [link](https://developers.weixin.qq.com/doc/offiaccount/Asset_Management/Get_materials_list.html){:target="_blank"}
  """
  @spec batch_get_material(SDK.client(), material_type, material_count, offset :: integer) ::
          SDK.response()
  def batch_get_material(client, type, count \\ 10, offset \\ 0) when count in 1..20 do
    client.request(
      :post,
      url: "/cgi-bin/material/batchget_material",
      body:
        json_map(
          type: type,
          offset: offset,
          count: count
        )
    )
  end
end
