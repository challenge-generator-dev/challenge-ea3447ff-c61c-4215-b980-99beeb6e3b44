import { OrderStatus } from '../types/order-status.type';

export class OrderItem {
  constructor(
    public readonly productId: string,
    public readonly quantity: number,
    public readonly price: number,
  ) {
    if (quantity <= 0) {
      throw new Error('Quantity must be greater than 0');
    }
    if (price <= 0) {
      throw new Error('Price must be greater than 0');
    }
  }

  getTotalPrice(): number {
    return this.quantity * this.price;
  }

  toJSON(): { productId: string; quantity: number; price: number } {
    return {
      productId: this.productId,
      quantity: this.quantity,
      price: this.price,
    };
  }
}

export class Order {
  constructor(
    public readonly id: string,
    public readonly customerId: string,
    public readonly items: OrderItem[],
    public status: OrderStatus,
    public readonly createdAt: string,
    public updatedAt: string,
  ) {
    if (!id || !customerId) {
      throw new Error('Id and customerId are required');
    }
    if (items.length === 0) {
      throw new Error('Order must have at least one item');
    }
  }

  updateStatus(newStatus: OrderStatus): void {
    this.status = newStatus;
    this.updatedAt = new Date().toISOString();
  }

  getTotalAmount(): number {
    return this.items.reduce((total, item) => total + item.getTotalPrice(), 0);
  }

  canTransitionTo(newStatus: OrderStatus): boolean {
    const allowedTransitions: Record<OrderStatus, OrderStatus[]> = {
      [OrderStatus.PENDING]: [OrderStatus.PROCESSING, OrderStatus.CANCELLED],
      [OrderStatus.PROCESSING]: [OrderStatus.SHIPPED, OrderStatus.CANCELLED],
      [OrderStatus.SHIPPED]: [OrderStatus.DELIVERED, OrderStatus.CANCELLED],
      [OrderStatus.DELIVERED]: [],
      [OrderStatus.CANCELLED]: [],
    };
    return allowedTransitions[this.status].includes(newStatus);
  }

  toJSON(): {
    id: string;
    customerId: string;
    items: { productId: string; quantity: number; price: number }[];
    status: OrderStatus;
    createdAt: string;
    updatedAt: string;
  } {
    return {
      id: this.id,
      customerId: this.customerId,
      items: this.items.map((item) => item.toJSON()),
      status: this.status,
      createdAt: this.createdAt,
      updatedAt: this.updatedAt,
    };
  }
}