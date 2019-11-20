export interface User {
  id: string;
  username: string | undefined;
  perms: Permission[] | undefined;
}

export interface Permission {
    comm: Community | undefined;
    commId: string;
    user: User | undefined;
    userId: string;
}

export interface Community {
    id: string;
    name: string | undefined;
    chats: Chat[];
}

export interface Chat {
    id: string;
    title: string | undefined;
    user: User;
    insertedAt: string;
    updatedAt: string;
    messages: Message[];
}

export interface Message {
    id: string;
    insertedAt: string;
    msg: string;
}
