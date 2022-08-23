require_relative 'mesh_factory'

class Human
	attr_reader:mesh

	def initialize(x, y, z)

		#MeshFactoryクラスを利用してノーマルな正方形のmeshを生成する
		@mesh = MeshFactory.generate(
			geom_type: :box,
			mat_type: :nomal,
			color: 0xffffff
		)

		self.mesh.position.x = x
		self.mesh.position.y = y
		self.mesh.position.z = z

		#defenderクラスからのコピペ
		# 交差判定用Raycasterの向きを決定する単位ベクトルを生成する
		@norm_vector = Mittsu::Vector3.new(0, 1, 0).normalize

		# 交差判定用のRaycasterオブジェクトを生成する
		@raycaster = Mittsu::Raycaster.new
	end

	#humanオブジェクトを爆発させて消す処理
	def self.operation(humans)
		removed_humans = []
	end
end