require_relative '../lib/mesh_factory.rb'

class Human
	attr_reader :mesh
	#bomb（たこやき）と人間が接触したとみなされる距離
	INTERCEPTABLE_DISTANCE = 2.0

	def initialize(x, y, z)
		#(x:,y,:,z:)
		#MeshFactoryクラスを利用してノーマルな正方形のmeshを生成する
		@mesh = MeshFactory.generate(
			geom_type: :box,
			mat_type: :phong,
			color: 0xffffff
		)

		# @grade = grade

		# 1フレームにおいてpopした人間を格納する配列を初期化
		# @humans = []

		self.mesh.position.x = x
		self.mesh.position.y = y
		self.mesh.position.z = z

		#defenderクラスからのコピペ
		# 交差判定用Raycasterの向きを決定する単位ベクトルを生成する
		@norm_vector = Mittsu::Vector3.new(0, 1, 0).normalize

		# 交差判定用のRaycasterオブジェクトを生成する
		@raycaster = Mittsu::Raycaster.new
	end

	# def humanAdd
	# 	@humans << Human.new(1,1,1)
	# end
	
	# def collect_humans
	# 	result = @humans.dup # 回収される爆弾を取り出す
	# 	@humans.clear # 爆弾保管用配列をクリアする
	# 	result
	# end

	#たこやきと接触したhumanの配列が返される処理を書く
	# def self.operation(humans)
	# 	removed_humans = []
	# 	humans.each do |human|
	# 		removed = human.move(ground_level)
	# 		removed_bombs << human if removed
	# 	end
	# 	return removed_bombs
	# end
	

	def hitted_bombs(bombs = [])
		intercepted_bombs = []
		bomb_map = {}
		bombs.each do |bomb|
			bomb_map[bomb.mesh] = bomb
		end
		meshes = bomb_map.keys
		@raycaster.set(self.mesh.position, @norm_vector)
		collisions = @raycaster.intersect_objects(meshes)
		if collisions.size > 0
			obj = collisions.first[:object] # 最も近距離にあるオブジェクトを得る
			if meshes.include?(obj)
				# 当該オブジェクトと、当たり判定元オブジェクトの位置との距離を測る
				distance = self.mesh.position.distance_to(obj.position)
				if distance <= INTERCEPTABLE_DISTANCE
					intercepted_bombs << bomb_map[obj]
				end
			end
		end
		intercepted_bombs
	end
 
end