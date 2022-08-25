require_relative '../lib/mesh_factory.rb'

class Human
	attr_reader :mesh, :grade
	#bomb（たこやき）と人間が接触したとみなされる距離
	INTERCEPTABLE_DISTANCE = 2.0

	def initialize(x, y, z, cratetime)
		#(x:,y,:,z:)
		#MeshFactoryクラスを利用してノーマルな正方形のmeshを生成する
		@mesh = MeshFactory.generate(
			geom_type: :box,
			mat_type: :phong,
			color: 0XD0E040
		)

		self.mesh.position.x = x
		self.mesh.position.y = y
		self.mesh.position.z = z

		@cratetime = cratetime
		
		#gradeには1~3までの数値が入る

		#defenderクラスからのコピペ
		# 交差判定用Raycasterの向きを決定する単位ベクトルを生成する
		@norm_vector = Mittsu::Vector3.new(0, 1, 0).normalize

		# 交差判定用のRaycasterオブジェクトを生成する
		@raycaster = Mittsu::Raycaster.new
	end

	def timeReturn
		@cratetime
	end

	def hitted_bombs(bombs = [])
		intercepted_bombs = []
		intercepted_humans = []
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
					intercepted_humans << self
				end
			end
		end
		return intercepted_bombs,intercepted_humans
	end
 
end