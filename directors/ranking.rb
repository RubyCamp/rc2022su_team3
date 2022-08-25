require_relative 'base'

module Directors
	# タイトル画面のシーン制御用ディレクタークラス
	class Ranking < Base
		# コンストラクタ
		def initialize(renderer:, aspect:, title_director:)
			# スーパークラスのコンストラクタ実行
			super(renderer: renderer, aspect: aspect)

			# タイトル画面の次に遷移する画面（ゲーム本編）用のディレクターオブジェクトを生成
			@title_director = title_director

			# 地球のメッシュを生成してシーンに追加
			# @earth = MeshFactory.get_earth
			# self.scene.add(@earth)
			geometry = Mittsu::PlaneGeometry.new(32, 24)
			texture_map = Mittsu::ImageUtils.load_texture("textures/result_tako.png")
			material = Mittsu::MeshLambertMaterial.new(map: texture_map)
			mesh = Mittsu::Mesh.new(geometry, material)
			self.scene.add(mesh)
			
			# テキスト用ボードオブジェクト追加
			title_back_board = TextBoard.new(texture_path: "textures/title_back.png", value: "TITLE", y: -5.0, scale_x: 3.5)
			self.scene.add(title_back_board.mesh)
			@selectors = {
				title_back_board.mesh => title_back_board
			}

			# Raycasterとマウス位置の単位ベクトルを収めるオブジェクトを生成
			@raycaster = Mittsu::Raycaster.new
			@mouse_position = Mittsu::Vector2.new

			# 光源追加
			add_lights

			# Mittsuのイベントをアクティベート（有効化）する
			activate_events
		end	
		
		# 1フレーム分のゲーム進行処理
		def render_frame
			# 少しずつ地球のメッシュを回転させる（自転を表現）
			# @earth.rotate_y(0.001)
		end

		private

		# マウスクリックイベントのハンドラを定義
		def mouse_clicked(button:, position:)
			if button == :m_left
				# TextBoardとの当たり判定を実行
				check_collisions(position)
			end
		end

		# TextBoardをクリックしたかどうかを判定する
		def check_collisions(position)
			# ウィンドウ座標から必要な単位ベクトルを生成
			@mouse_position.x = ((position.x / @renderer.width) * 2.0 - 1.0)
			@mouse_position.y = ((position.y / @renderer.height) * -2.0 + 1.0)

			# 当たり判定実行
			@raycaster.set_from_camera(@mouse_position, self.camera.instance)
			intersects = @raycaster.intersect_objects(@selectors.keys)
			# 交差判定を得られた先頭のオブジェクトが持つ値を次のシーンに送り、シーン切り替えする
			intersected = intersects.first
			if intersected
				text_board = @selectors[intersected[:object]]
				if text_board.value == "TITLE"
					transition
				end
			end
		end

		# シーン切り替え実行
		def transition
			transition_scene(@title_director)
		end

		# シーンに光源を追加
		def add_lights
			# 地球を照らすための照明
			tako_light = Mittsu::DirectionalLight.new(0xffffff)
			tako_light.position.set(0, 0, 10)
			self.scene.add(tako_light)

			# 文字ボードを照らすための照明
			text_light = Mittsu::SpotLight.new(0xffffff)
			text_light.angle = Math::PI / 2
			text_light.position.set(0, -1, 10)
			self.scene.add(text_light)
		end
	end
end