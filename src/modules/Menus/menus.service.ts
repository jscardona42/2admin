import { Injectable, NotFoundException, UnauthorizedException } from '@nestjs/common';
import { LoginService } from '../Login/login.service';
import { UsuariosService } from '../Usuarios/usuarios.service';
import { PrismaService } from '../../prisma.service';
import { CreateMenuInput } from './dto/menus.dto';
import { EntidadesService } from '../Admin/Entidades/entidades.service';
import { RolesService } from '../Admin/Roles/roles.service';


@Injectable()
export class MenusService {
  constructor(
    private prismaService: PrismaService,
    private loginService: LoginService,
    private usuariosService: UsuariosService,
    private entidadesService: EntidadesService,
    private rolesService: RolesService
  ) { }

  // Obtener todos los menús
  async getMenus(): Promise<any> {
    return this.prismaService.menus.findMany({
      where: {
        menu_id: 1,
      },
      include: {
        MenusTraducciones: true, MenusPalabras: true,
        other_Menus: {
          where: { activo: true },
          include: {
            MenusTraducciones: true, MenusPalabras: true,
            other_Menus: {
              where: { activo: true },
              include: {
                MenusTraducciones: true, MenusPalabras: true,
                other_Menus: {
                  where: { activo: true },
                  include: {
                    MenusTraducciones: true, MenusPalabras: true,
                    other_Menus: true
                  }
                }
              }
            }
          }
        }
      }
    });
  }

  async getMenuById(menu_id: number): Promise<any> {
    return await this.prismaService.menus.findUnique({
      where: { menu_id: menu_id }
    });
  }

  // Obtener todos los menús
  async getMenusInactivos(): Promise<any> {
    return await this.prismaService.menus.findMany({
      where: { activo: false }
    });
  }

  // Otener menú dependiendo el rol
  async getMenuByRoleId(login_id: number): Promise<Object[]> {

    var arrayEntidadIds = [];
    var arrayPermisosIds = [];

    var login = await this.loginService.getLoginById(login_id);

    if (login === null) {
      throw new UnauthorizedException("The user does not have a menu configured");
    }
    var usuario = await this.usuariosService.getUsuarioById(login.usuario_id);

    if (usuario === null) {
      throw new UnauthorizedException("The user does not have a menu configured");
    }
    var entidadIds = await this.rolesService.getEntidadesIdsByRolId(login.rol_id);

    entidadIds.forEach(function (permiso, index) {
      arrayPermisosIds[index] = permiso.Permisos;
    });

    arrayPermisosIds.forEach(function (entidad, index) {
      arrayEntidadIds[index] = entidad.entidad_id;
    });

    const OR = [{ entidad_id: { in: arrayEntidadIds }, }, { isEntity: false }, { activo: true }];

    return await this.prismaService.menus.findMany({
      where: {
        menu_id: 1,
      },
      include: {
        MenusTraducciones: true, MenusPalabras: true,
        other_Menus: {
          where: { OR: OR },
          include: {
            MenusTraducciones: true, MenusPalabras: true,
            other_Menus: {
              where: { OR: OR },
              include: {
                MenusTraducciones: true, MenusPalabras: true,
                other_Menus: {
                  where: { OR: OR },
                  include: {
                    MenusTraducciones: true, MenusPalabras: true,
                    other_Menus: true
                  }
                }
              }
            }
          }
        }
      }
    })
  }

  // Filtrar menú por palabra
  async getFilterMenuPalabra(palabra: string): Promise<Object[]> {
    return this.prismaService.menus.findMany({
      where: { MenusPalabras: { some: { palabra: { contains: palabra, mode: "insensitive" } } }, activo: true }
    })
  }


  // Crear root menú
  async createRootMenu(): Promise<Object> {
    return await this.prismaService.menus.create({
      data: {
        title: 'menu',
        path: '/',
        isEntity: false,
        parentMenuId: null,
      },
    });
  }

  // Crear una carpeta
  async createFolder(data: CreateMenuInput): Promise<Object> {
    await this.doesParentFolderExist(data.parentId);
    const createdFolder = await this.prismaService.menus.create({
      data: {
        title: data.name,
        isEntity: false,
        order: data.order,
        icon: data.icon,
        path: '',
        Menus: {
          connect: {
            menu_id: data.parentId,
          },
        },
      },
    });
    return await this.updateFolderPath(createdFolder.menu_id, data.name);
  }

  // Crear entidad
  async insertEntityToFolder(data: CreateMenuInput): Promise<Object> {

    await this.entidadesService.getEntidadeById(data.entidad_id);

    const createdEntity = await this.prismaService.menus.create({
      data: {
        title: data.name,
        isEntity: true,
        path: '',
        order: data.order,
        icon: data.icon,
        Menus: { connect: { menu_id: data.parentId, }, },
        entidad_id: data.entidad_id
      },
    });
    return await this.updateFolderPath(createdEntity.menu_id, data.name);
  }

  // Validar si existe el parentId
  async doesParentFolderExist(parentId: number): Promise<void> {
    await this.prismaService.menus.findUnique({
      where: {
        menu_id: parentId,
      },
      rejectOnNotFound: () =>
        new NotFoundException(`Folder with id: ${parentId} does not exist`),
    });
  }

  // Actualizar path
  async updateFolderPath(folderId: number, folderName: string): Promise<Object> {
    let path: string;
    const parent = await this.prismaService.menus
      .findUnique({
        where: {
          menu_id: folderId,
        },
      })
      .Menus({
        select: {
          path: true,
        },
      });
    if (parent.path === '/') {
      path = parent.path + folderName;
    } else {
      path = parent.path + '/' + folderName;
    }

    var level = path.split("/").length - 1;

    return await this.prismaService.menus.update({
      where: {
        menu_id: folderId,
      },
      data: {
        path: path.replace(" ", "").toLowerCase(),
        level: level
      },
    });
  }

  // Actualizar el menú completo
  async updateMenu(data: string): Promise<Object[]> {
    var menu = JSON.parse(data);

    menu.other_Menus.forEach(async nivel1 => {
      await this.entidadesService.getEntidadeById(nivel1.entidad_id);
      if (nivel1.menu_id !== 0) {
        await this.prismaService.menus.update({
          where: { menu_id: nivel1.menu_id },
          data: {
            title: nivel1.title,
            path: nivel1.path,
            level: nivel1.level,
            entidad_id: nivel1.entidad_id,
            isEntity: nivel1.isEntity,
            order: nivel1.order,
            icon: nivel1.icon,
            parentMenuId: nivel1.parentMenuId
          }
        })
      } else {
        await this.prismaService.menus.create({
          data: {
            title: nivel1.title,
            path: nivel1.path,
            level: nivel1.level,
            entidad_id: nivel1.entidad_id,
            isEntity: nivel1.isEntity,
            order: nivel1.order,
            icon: nivel1.icon,
            parentMenuId: nivel1.parentMenuId
          }
        })
      }


      nivel1.other_Menus.forEach(async nivel2 => {
        await this.entidadesService.getEntidadeById(nivel2.entidad_id);
        if (nivel2.menu_id !== 0) {
          await this.prismaService.menus.update({
            where: { menu_id: nivel2.menu_id },
            data: {
              title: nivel2.title,
              path: nivel2.path,
              level: nivel2.level,
              entidad_id: nivel2.entidad_id,
              isEntity: nivel2.isEntity,
              order: nivel2.order,
              icon: nivel2.icon,
              parentMenuId: nivel2.parentMenuId
            }
          })
        } else {
          await this.prismaService.menus.create({
            data: {
              title: nivel2.title,
              path: nivel2.path,
              level: nivel2.level,
              entidad_id: nivel2.entidad_id,
              isEntity: nivel2.isEntity,
              order: nivel2.order,
              icon: nivel2.icon,
              parentMenuId: nivel2.parentMenuId
            }
          })
        }

        nivel2.other_Menus.forEach(async nivel3 => {
          await this.entidadesService.getEntidadeById(nivel3.entidad_id);
          if (nivel3.menu_id !== 0) {
            await this.prismaService.menus.update({
              where: { menu_id: nivel3.menu_id },
              data: {
                title: nivel3.title,
                path: nivel3.path,
                level: nivel3.level,
                entidad_id: nivel3.entidad_id,
                isEntity: nivel3.isEntity,
                order: nivel3.order,
                icon: nivel3.icon,
                parentMenuId: nivel3.parentMenuId
              }
            })
          } else {
            await this.prismaService.menus.create({
              data: {
                title: nivel3.title,
                path: nivel3.path,
                level: nivel3.level,
                entidad_id: nivel3.entidad_id,
                isEntity: nivel3.isEntity,
                order: nivel3.order,
                icon: nivel3.icon,
                parentMenuId: nivel3.parentMenuId
              }
            })
          }
        });
      });
    });
    return await this.prismaService.menus.findMany({
      include: { other_Menus: { include: { other_Menus: { include: { other_Menus: true } } } } }
    })

  }

  async modifyMenuEstado(menu_id: number, activo: boolean): Promise<Object> {
    return await this.prismaService.menus.update({
      where: { menu_id: menu_id },
      data: { activo: activo }
    })
  }



}
