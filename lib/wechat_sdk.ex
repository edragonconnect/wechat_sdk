defmodule WeChat.SDK do
  @moduledoc false

  @type appid :: String.t()
  @type openid :: String.t()
  @type unionid :: String.t()
  @type username :: String.t()

  @type client :: module
  @type response :: {:ok, status :: integer, data :: map} | {:error, %WeChat.Error{}}

  @common_modules [
    WeChat.SDK.Material,
    WeChat.SDK.DraftBox,
    WeChat.SDK.Publish,
    WeChat.SDK.Card,
    WeChat.SDK.CardManaging,
    WeChat.SDK.CardDistributing,
    WeChat.SDK.CustomService,
    WeChat.SDK.CustomMessage,
    WeChat.SDK.BatchSends,
    WeChat.SDK.Template,
    WeChat.SDK.User,
    WeChat.SDK.UserTag,
    WeChat.SDK.UserBlacklist,
    WeChat.SDK.Account,
    WeChat.SDK.Comment,
    WeChat.SDK.JS,
    WeChat.SDK.SubscribeMessage
  ]

  defmacro __using__(opts \\ []) do
    {role, opts} = Keyword.pop(opts, :role, :common)
    {app_type, opts} = Keyword.pop(opts, :app_type, :official_account)

    case role in [:common, :component] do
      true -> :skip
      false -> raise ArgumentError, "please set role in [:common, :component]"
    end

    sub_modules =
      case role do
        :common ->
          case app_type do
            :official_account -> @common_modules
            :mini_program -> [WeChat.SDK.MiniProgram]
          end

        :component ->
          case app_type do
            :official_account -> [WeChat.SDK.Component | @common_modules]
            :mini_program -> [WeChat.SDK.Component, WeChat.SDK.MiniProgram]
          end
      end

    {sub_module_ast_list, files} =
      Enum.map_reduce(
        sub_modules,
        [],
        fn module, acc ->
          {file, ast} = gen_sub_module(module, __CALLER__.module)
          {ast, [quote(do: @external_resource(unquote(file))) | acc]}
        end
      )

    default_opts =
      opts
      |> Macro.prewalk(&Macro.expand(&1, __CALLER__))
      |> Keyword.take([:adapter_storage, :appid, :authorizer_appid, :scenario, :secret_key])

    [gen_request(role, app_type, default_opts) | files] ++ sub_module_ast_list
  end

  defp gen_request(role, app_type, default_opts) do
    request_function =
      Enum.join([role, "request"], "_")
      |> String.to_atom()

    appid =
      case role do
        :common -> Keyword.get(default_opts, :appid)
        :component -> Keyword.get(default_opts, :authorizer_appid)
      end

    quote do
      require Logger

      def default_opts, do: unquote(default_opts)
      def appid, do: unquote(appid)
      def app_type, do: unquote(app_type)

      @doc """
      See WeChat.request/2 for more information.
      """
      @spec request(method :: WeChat.method(), options :: Keyword.t()) ::
              {:ok, term()} | {:error, WeChat.error()}
      def request(method, options) do
        options = WeChat.Utils.merge_keyword(options, unquote(default_opts))

        case apply(WeChat, unquote(request_function), [method, options]) do
          {:ok, %{status: status, body: body}} ->
            {:ok, status, body}

          response ->
            response
        end
      end

      defoverridable request: 2
    end
  end

  defp gen_sub_module(module, parent_module) do
    file = module.__info__(:compile)[:source]

    {:ok, ast} =
      file
      |> File.read!()
      |> Code.string_to_quoted()

    file =
      to_string(file)
      |> String.split("/")
      |> Enum.drop_while(&(&1 != "wechat_sdk"))
      |> Path.join()

    client_module =
      parent_module
      |> Module.split()
      |> List.last()
      |> String.to_atom()

    new_module_name =
      module
      |> Module.split()
      |> List.last()
      |> String.to_atom()

    ast =
      Macro.prewalk(
        ast,
        fn
          {:defmodule, c_m, [{:__aliases__, c_a, _}, do_list]} ->
            [do: {:__block__, [], list}] = do_list

            do_list = [
              do:
                {:__block__, [],
                 [
                   quote(do: alias(unquote(parent_module))),
                   quote(do: @file(unquote(to_string(module))))
                   | list
                 ]}
            ]

            {:defmodule, c_m, [{:__aliases__, c_a, [new_module_name]}, do_list]}

          {:spec, c_s, ast} ->
            # del first argument
            ast =
              Macro.prewalk(
                ast,
                fn
                  {fun_name, context, [{{:., _, [{:__aliases__, _, _}, :client]}, _, _} | args]}
                  when is_atom(fun_name) ->
                    {fun_name, context, args}

                  sub_ast ->
                    sub_ast
                end
              )

            {:spec, c_s, ast}

          {:def, c_s, ast} ->
            ast =
              Macro.prewalk(
                ast,
                fn
                  {:., context, [{:client, c_c, nil}, fun_name]} ->
                    # replace first argument
                    {:., context, [{:__aliases__, c_c, [client_module]}, fun_name]}

                  {fun_name, context, [{:client, _, nil} | args]} when is_atom(fun_name) ->
                    # del first argument
                    {fun_name, context, args}

                  sub_ast ->
                    sub_ast
                end
              )

            {:def, c_s, ast}

          ast ->
            # IO.inspect(ast)
            ast
        end
      )

    {file, ast}
  end

  defmodule Article do
    @moduledoc "文章"

    @typedoc """
    | argument            | 是否必须 | 说明 |
    | ------------------- | ------ | --- |
    | title               | 是 | 标题 |
    | thumb_media_id      | 是 | 图文消息的封面图片素材id（必须是永久mediaID）|
    | author              | 否 | 作者 |
    | digest              | 否 | 图文消息的摘要，仅有单图文消息才有摘要，多图文此处为空。如果本字段为没有填写，则默认抓取正文前64个字。 |
    | show_cover_pic      | 是 | 是否显示封面，0为false，即不显示，1为true，即显示 |
    | content             | 是 | 图文消息的具体内容，支持HTML标签，必须少于2万字符，小于1M，且此处会去除JS,涉及图片url必须来源 "上传图文消息内的图片获取URL"接口获取。外部图片url将被过滤。 |
    | content_source_url  | 是 | 图文消息的原文地址，即点击“阅读原文”后的URL |
    | need_open_comment   | 否 | Uint32 是否打开评论，0不打开，1打开 |
    | only_fans_can_comment | 否 | Uint32 是否粉丝才可评论，0所有人可评论，1粉丝才可评论 |
    """
    @type t :: %__MODULE__{
            title: String.t(),
            thumb_media_id: WeChat.SDK.Material.media_id(),
            author: String.t(),
            digest: String.t(),
            show_cover_pic: integer,
            content: String.t(),
            content_source_url: String.t(),
            need_open_comment: integer,
            only_fans_can_comment: integer
          }

    defstruct [
      :title,
      :thumb_media_id,
      :author,
      :digest,
      {:show_cover_pic, 1},
      :content,
      {:content_source_url, ""},
      {:need_open_comment, 1},
      {:only_fans_can_comment, 1}
    ]
  end

  def doc_link_prefix, do: "https://developers.weixin.qq.com/doc"

  @spec build_client(client, options :: map) :: {:ok, client}
  def build_client(module_name, options) do
    with {:module, module, _binary, _term} <-
           Module.create(
             module_name,
             quote do
               @moduledoc "#{unquote(module_name)}"
               use WeChat.SDK, unquote(options)
             end,
             Macro.Env.location(__ENV__)
           ) do
      {:ok, module}
    end
  end
end
