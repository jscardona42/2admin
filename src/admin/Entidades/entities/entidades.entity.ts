import { Field, ID, ObjectType } from "@nestjs/graphql"

@ObjectType()
export class Entidades {
    @Field((type) => ID)
    entidad_id: number

    @Field((type) => String)
    nombre: string

    @Field((type) => String, { nullable: true })
    resolver?: string

}