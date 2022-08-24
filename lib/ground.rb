require_relative 'mesh_factory'

# 地表オブジェクトを定義するクラス
class Ground
	# 地表の3D形状へのアクセサ
	attr_reader :mesh

	# コンストラクタ
	def initialize(size: 100.0, level: 0)
		@mesh = MeshFactory.generate(
		 	geom_type: :box,
		 	mat_type: :phong,
		 	scale_x: size,
		 	scale_y: 0.1,
		 	scale_z: size,
		 	texture_map: MeshFactory.get_texture("textures/ground.png")
			# color: 0xff0000
		)
		@mesh.position.y = level
	end
end