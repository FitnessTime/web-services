require_relative '../Assemblers/MarcaAssembler.rb'

FitnessTimeApi::App.controllers :marcaService do
  
  post :registrarMarca, :map => '/marcas' do
    #securityToken = SecurityToken.find_by_authToken(params[:authToken])
    if false
      get_error_response(404,"Usuario no autorizado.")
    else
      jsonMarca = JSON.parse(params[:marca])
      ejercicio = EjercicioDeCarga.find_by_id(jsonMarca['idEjercicio'])
      marca = create_marca(jsonMarca, ejercicio)
      get_success_response("")
    end
  end

  get :marcas, :map => '/marcas' do
    #securityToken = SecurityToken.find_by_authToken(params[:authToken])
    #if securityToken == nil
    #  get_error_response(404,"Usuario no autorizado.")
    #else
      rutinas = Rutina.find_all_by_eliminada(false)
      ret_estadisticas_marcas = Array.new(rutinas.size)
      assembler = MarcaAssembler.new
      indexx = 0
      rutinas.each do |rutina|
        index = 0
        ret_ejercicio_marcas = Array.new(rutinas.ejercicios.size)
        rutina.ejercicios.each do |ejercicio|
          marcas = Marca.find_all_by_ejercicio_id(ejercicio.id)
          if marcas != nil && marcas.size > 0
            marcas_dto = Array.new(marcas.size)
            i=0
            marcas.each do |marcaa|
              marcas_dto[i] = assembler.crear_dto(marcaa)
              i = i + 1
            end
            marca = EjercicioMarcas.new(ejercicio, marcas_dto)
            ret_ejercicio_marcas[index] = marca
            index = index + 1
          end
        end
        ret_estadisticas_marcas[indexx] = EstadisticasMarcas.new(rutina, ret_ejercicio_marcas)
      end
      return ret_estadisticas_marcas.to_json
    #end
  end

  get :consultarEjercicio, :map => '/rutinas/:rutina_id/ejercicios/:ejercicio_id/marcas/:marca_id' do
    @marca = Marca.get!(params[:marca_id])
    #Comunicamos el resultado de la operacion y mandamos el json
  end
end
