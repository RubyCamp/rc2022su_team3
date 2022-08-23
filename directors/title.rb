require_relative 'base'

module Directors
	# タイトル画面のシーン制御用ディレクタークラス
	class Title < Base
		# コンストラクタ
		def initialize(renderer:, aspect:)
			# スーパークラスのコンストラクタ実行
			super

			# タイトル画面の次に遷移する画面（ゲーム本編）用のディレクターオブジェクトを生成
			@game_director = Directors::Game.new(renderer: renderer, aspect: aspect)

			# 地球のメッシュを生成してシーンに追加
			@earth = MeshFactory.get_earth
			self.scene.add(@earth)

			# テキスト用ボードオブジェクト追加
			vs_com_board = TextBoard.new(texture_path: "textures/solo_play.png", value: Directors::Game::VS_COM_MODE, y: -0.5, scale_x: 3.5)
			vs_player_board = TextBoard.new(texture_path: "textures/multi_play.png", value: Directors::Game::VS_PLAYER_MODE, y: -1.7, scale_x: 3.5)
			self.scene.add(vs_com_board.mesh)
			self.scene.add(vs_player_board.mesh)
			@selectors = {
				vs_com_board.mesh => vs_com_board,
				vs_player_board.mesh => vs_player_board
			}

			# Raycasterとマウス位置の単位ベクトルを収めるオブジェクトを生成
			@raycaster = Mittsu::Raycaster.new
			@mouse_position = Mittsu::Vector2.new

			# 光源追加
			add_lights

			# Mittsuのイベントをアクティベート（有効化）する
			activate_events
		end