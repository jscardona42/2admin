import { Injectable, UnauthorizedException } from '@nestjs/common';
import { PrismaService } from '../../../prisma.service'
import { CreateTipoUsuarioInput, FilterTipoUsuariosInput, UpdateTipoUsuarioInput } from './dto/tipousuarios.dto';

@Injectable()
export class TbTipoUsuariosService {
    constructor(
        private prismaService: PrismaService,
    ) { }

    async getTipoUsuarios(): Promise<any> {
        return this.prismaService.tbTipoUsuarios.findMany({
            include: { Usuarios: true },
            orderBy: { tipo_usuario_id: "asc" }
        });
    }

    async getTipoUsuarioById(tipo_usuario_id: number): Promise<any> {
        let usuarios = await this.prismaService.tbTipoUsuarios.findUnique({
            where: { tipo_usuario_id: tipo_usuario_id },
            include: { Usuarios: true }
        })

        if (usuarios === null) {
            throw new UnauthorizedException(`El tipo de usuario con id ${tipo_usuario_id} no existe`);
        }
        return usuarios;
    }

    async getFilterTipoUsuarios(data: FilterTipoUsuariosInput): Promise<any> {
        return this.prismaService.tbTipoUsuarios.findMany({
            where: data,
            orderBy: { tipo_usuario_id: "asc" }
        })
    }

    async createTipoUsuario(data: CreateTipoUsuarioInput): Promise<any> {
        return this.prismaService.tbTipoUsuarios.create({
            data: {
                ...data
            },
            include: { Usuarios: true }
        });
    }

    async updateTipoUsuario(data: UpdateTipoUsuarioInput): Promise<any> {

        await this.getTipoUsuarioById(data.tipo_usuario_id);

        return this.prismaService.tbTipoUsuarios.update({
            where: { tipo_usuario_id: data.tipo_usuario_id },
            data: {
                ...data
            },
            include: { Usuarios: true }
        });
    }

    async deleteTipoUsuario(tipo_usuario_id: number): Promise<any> {

        await this.getTipoUsuarioById(tipo_usuario_id);

        return this.prismaService.tbTipoUsuarios.delete({
            where: { tipo_usuario_id: tipo_usuario_id },
            include: { Usuarios: true }
        });
    }
}
