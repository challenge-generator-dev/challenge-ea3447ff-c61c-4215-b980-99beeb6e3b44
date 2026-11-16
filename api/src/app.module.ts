import { Module } from '@nestjs/common';
import { OrderController } from './infrastructure/controllers/order.controller';
import { OrderService } from './application/services/order.service';
import { OrderRepository } from './infrastructure/repositories/order.repository';

@Module({
  controllers: [OrderController],
  providers: [
    OrderService,
    {
      provide: 'OrderRepositoryPort',
      useClass: OrderRepository,
    },
  ],
})
export class AppModule {}