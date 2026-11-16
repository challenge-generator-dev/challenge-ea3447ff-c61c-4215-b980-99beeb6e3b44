import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { OrderService } from '../services/OrderService';
import { CreateOrderDto, Order, UpdateOrderDto } from '../types/order';

export const useOrder = () => {
  const queryClient = useQueryClient();

  const getOrderQuery = (orderId: string) =>
    useQuery<Order, Error>({
      queryKey: ['order', orderId],
      queryFn: () => OrderService.getOrder(orderId),
      enabled: !!orderId,
    });

  const createOrderMutation = useMutation<Order, Error, CreateOrderDto>({
    mutationFn: (orderData) => OrderService.createOrder(orderData),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['orders'] });
    },
  });

  const updateOrderMutation = useMutation<Order, Error, { orderId: string; updateData: UpdateOrderDto }>({
    mutationFn: ({ orderId, updateData }) => OrderService.updateOrder(orderId, updateData),
    onSuccess: (_, { orderId }) => {
      queryClient.invalidateQueries({ queryKey: ['order', orderId] });
      queryClient.invalidateQueries({ queryKey: ['orders'] });
    },
  });

  const deleteOrderMutation = useMutation<void, Error, string>({
    mutationFn: (orderId) => OrderService.deleteOrder(orderId),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['orders'] });
    },
  });

  return {
    getOrderQuery,
    createOrderMutation,
    updateOrderMutation,
    deleteOrderMutation,
  };
};