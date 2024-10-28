extends Node3D

#see Vehicle_VehicleBody3D for custom amounts on mystic peaks
func _physics_process(_delta): #snowFX value is set by vehicles Y position / elevation
	$F1snow_GPUParticles3D.amount = NfsgpSingleton.snowFX
	$F2snow_GPUParticles3D.amount = NfsgpSingleton.snowFX
	$F3snow_GPUParticles3D.amount = NfsgpSingleton.snowFX
	$F4snow_GPUParticles3D.amount = NfsgpSingleton.snowFX
	$R1snow_GPUParticles3D.amount = NfsgpSingleton.snowFX
	$R2snow_GPUParticles3D.amount = NfsgpSingleton.snowFX
